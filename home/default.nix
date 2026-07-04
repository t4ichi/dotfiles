{ username, ... }:
{
  # Phase 4 で ./dotfiles.nix を追加
  imports = [ ./packages.nix ./claude-code.nix ./zsh.nix ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # 初回固定。以後は変更しないこと
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
