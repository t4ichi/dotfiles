{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # git / GitHub
    git
    gh

    # editor / multiplexer
    neovim
    tmux

    # search / navigation
    ripgrep
    fd
    fzf
    tree

    # dev tooling
    lazygit

    # languages / runtimes
    go
    rustup
    nodejs
    pnpm

    # file / shell utils
    uv
    wget
    curl

    # media
    ffmpeg
    imagemagick
  ];
}
