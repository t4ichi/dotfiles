{ pkgs, ... }:
{
  # フォントは Nix で宣言的に管理（cask から移行）
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
