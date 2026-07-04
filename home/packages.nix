{ pkgs, ... }:
{
  # CLI ツール（旧 .Brewfile の formulae を Nix へ移行）
  # 名前は `nix search nixpkgs <name>` で確認可能。
  home.packages = with pkgs; [
    # git / GitHub
    git
    gh

    # editor / multiplexer
    neovim
    tmux

    # search / navigation
    ripgrep
    fzf
    tree

    # dev tooling
    lazygit
    lazydocker
    lefthook

    # languages / runtimes
    go
    rustup
    nodejs
    pnpm

    # file / shell utils
    yazi
    zoxide
    uv
    wget
    curl

    # media
    ffmpeg
    imagemagick
    mpv

    # build toolchain
    cmake
    gcc
    lua
    luarocks
    protobuf

    # misc
    genact
    fastfetch
    duktape
    posting
  ];

  # 補足:
  # - node -> nodejs, neofetch -> fastfetch（開発終了のため）, rust -> rustup に読み替え
  # - powerlevel10k / zsh-autosuggestions / zsh-syntax-highlighting / zsh は Phase 3 で扱う
  # - nvm / pyenv / python@3.10 はスコープ外（Homebrew に残す）
}
