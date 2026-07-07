{ username, ... }:
{
  imports = [
    ./homebrew.nix
    ./fonts.nix
    ./defaults.nix
  ];

  # 対象ユーザ（home-manager 連携に必要）
  users.users.${username}.home = "/Users/${username}";

  # homebrew 等のユーザ紐付けオプションに必要（root 実行アクティベーションの移行対応）
  system.primaryUser = username;

  # Determinate Nix を使用しているため、nix-darwin 側の Nix 管理は無効化する。
  # （Determinate が独自デーモンで nix.conf を管理し、flakes も標準で有効）
  nix.enable = false;

  # nix-darwin が管理する nixpkgs のプラットフォーム
  nixpkgs.hostPlatform = "aarch64-darwin";

  # VSCode 拡張の一部（ms-vscode-remote / vsliveshare / 言語パック等）が unfree のため許可
  nixpkgs.config.allowUnfree = true;

  # 初回のみ設定。以後は変更しないこと
  system.stateVersion = 5;
}
