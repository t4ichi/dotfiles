{ username, ... }:
{
  # macOS システム環境設定（旧 .bin/defaults.sh を宣言化）
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
