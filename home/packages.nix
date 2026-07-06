{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # git / GitHub
    git
    gh

    # herdr は Homebrew(brews) で管理
    # ghostty は programs.ghostty（home/ghostty.nix）で管理

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
    mise      # ランタイムのバージョン管理（nvm を置き換え）

    # languages / runtimes（node/pnpm は mise で管理）
    go
    rustup

    # file / shell utils
    uv
    wget
    curl

    # media
    ffmpeg
    imagemagick
  ];
}
