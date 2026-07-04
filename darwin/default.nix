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
      "herdr"   # ターミナル多重化（homebrew-core）
      "nvm"     # スコープ外だが当面維持（将来 Nix devshell 化を検討）
    ];

    casks = [
      "arc"
      "google-chrome"
      "claude"
      "slack"
      "obsidian"
      "docker"
      "visual-studio-code"
      "postman"
      "ghostty"
      "raycast"
      "nani"
      "font-jetbrains-mono-nerd-font"
    ];
  };

  # Phase 5 で system.defaults を追記
}
