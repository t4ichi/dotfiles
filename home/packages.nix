{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # git / GitHub
    git
    gh

    # terminal multiplexer（herdr は公式 flake から）
    inputs.herdr.packages.${pkgs.system}.default

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
