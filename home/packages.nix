{ pkgs, ... }:
{
  # CLI ツール（旧 .Brewfile の formulae から実際に使うものだけ Nix へ移行）
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
    fd
    fzf
    tree

    # dev tooling
    lazygit
    lazydocker

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

  # 棚卸しで削除したもの:
  # yazi(エイリアスごと廃止), zoxide(未初期化で未使用), lua/luarocks(依存プラグインなし),
  # cmake/gcc(clangで足りる), mpv, protobuf, genact, fastfetch, duktape, posting,
  # lefthook(プロジェクト側で管理)
  # スコープ外で Homebrew に残す: nvm
}
