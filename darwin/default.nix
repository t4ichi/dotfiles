{ pkgs, username, ... }:
{
  # 対象ユーザ（home-manager 連携に必要）
  users.users.${username}.home = "/Users/${username}";

  # homebrew 等のユーザ紐付けオプションに必要（root 実行アクティベーションの移行対応）
  system.primaryUser = username;

  # Determinate Nix を使用しているため、nix-darwin 側の Nix 管理は無効化する。
  # （Determinate が独自デーモンで nix.conf を管理し、flakes も標準で有効）
  nix.enable = false;

  # nix-darwin が管理する nixpkgs のプラットフォーム
  nixpkgs.hostPlatform = "aarch64-darwin";

  # 初回のみ設定。以後は変更しないこと
  system.stateVersion = 5;

  # GUI アプリ・フォント・サービスは Homebrew を宣言的に管理する。
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;   # switch のたびに brew update しない（初期は現状維持）
      upgrade = false;      # 自動アップグレードしない
      cleanup = "none";     # 宣言外の brew/cask を削除しない（安全のため初期は none）
    };

    taps = [ ];

    brews = [
      "nvm"     # スコープ外だが当面維持（将来 Nix devshell 化を検討）
    ];

    casks = [
      "arc"
      "google-chrome"
      "claude"
      "slack"
      "obsidian"
      "docker-desktop"
      "visual-studio-code"
      "postman"
      "raycast"
      "nani"
    ];
  };

  # フォントは Nix で宣言的に管理（cask から移行）
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # macOS 設定（旧 .bin/defaults.sh を宣言化）
  system.defaults = {
    # キーボード
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;   # キーリピート優先（長押しアクセント無効）
      InitialKeyRepeat = 12;
      KeyRepeat = 1;
      AppleEnableSwipeNavigateWithScrolls = true;
    };

    # Dock
    dock = {
      magnification = true;
      largesize = 128;
      tilesize = 40;
      autohide = true;
    };

    # トラックパッド（ネイティブ対応分）
    trackpad = {
      Clicking = true;                # タップでクリック
      TrackpadThreeFingerDrag = true; # 3本指ドラッグ
    };

    # ネイティブオプションが無いものは domain 指定で直接書き込む
    CustomUserPreferences = {
      NSGlobalDomain = {
        "com.apple.mouse.scaling" = 3.0;       # マウス速度
        "com.apple.scrollwheel.scaling" = 1;   # スクロール速度
      };
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadFourFingerHorizSwipeGesture = 2;
      };
    };
  };

  # シンボリックホットキー27は -dict-add のマージ意味を保つため、root実行のpostActivationから
  # sudo -u でユーザーとして defaults write する（activationはroot統一されたため）
  system.activationScripts.postActivation.text = ''
    sudo -u ${username} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"
  '';
}
