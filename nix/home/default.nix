{ username, ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./claude-code.nix
    ./symlinks.nix
    ./git.nix
    ./vscode.nix
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # 初回固定。以後は変更しないこと
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
