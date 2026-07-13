{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # git / GitHub
    git
    gh

    # herdr は Homebrew(brews) で管理
    # ghostty は Homebrew(cask)。設定は .config/ghostty/config を symlink 管理

    # editor（マルチプレクサは herdr を使用）
    neovim
    tree-sitter   # nvim-treesitter(main) がパーサのビルドに必要とする CLI

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
