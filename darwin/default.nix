{ pkgs, username, ... }:
{
  # 対象ユーザ（home-manager 連携に必要）
  users.users.${username}.home = "/Users/${username}";

  # Determinate Nix を使用しているため、nix-darwin 側の Nix 管理は無効化する。
  # （Determinate が独自デーモンで nix.conf を管理し、flakes も標準で有効）
  nix.enable = false;

  # nix-darwin が管理する nixpkgs のプラットフォーム
  nixpkgs.hostPlatform = "aarch64-darwin";

  # 初回のみ設定。以後は変更しないこと
  system.stateVersion = 5;

  # Phase 2 で homebrew（casks/taps/brews）を追記
  # Phase 5 で system.defaults を追記
}
