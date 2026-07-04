{ pkgs, username, ... }:
{
  # 対象ユーザ（home-manager 連携に必要）
  users.users.${username}.home = "/Users/${username}";

  # flakes / nix-command を有効化
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # nix-darwin 自体が管理する nixpkgs のプラットフォーム
  nixpkgs.hostPlatform = "aarch64-darwin";

  # 初回のみ設定。以後は変更しないこと
  system.stateVersion = 5;

  # Phase 2 で homebrew（casks/taps/brews）を追記
  # Phase 5 で system.defaults を追記
}
