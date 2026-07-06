{ config, ... }:
let
  dots = "${config.home.homeDirectory}/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  # 頻繁に編集する設定は「リポジトリ実体への live シンボリックリンク」で管理する。
  # mkOutOfStoreSymlink により、リポジトリを直接編集→即反映（rebuild 不要）を維持する。
  # （旧 .bin/link.sh の置き換え）
  home.file = {
    ".tmux.conf".source = link "${dots}/.tmux.conf";

    # Claude Code（~/.claude はデータ用ディレクトリ。settings.json のみ管理）
    ".claude/settings.json".source = link "${dots}/.claude/settings.json";

    # ~/.config 配下（nvim は LazyVim が書き込むため symlink 管理のまま）
    ".config/nvim".source = link "${dots}/.config/nvim";

    # herdr はランタイムファイル（socket/log/session.json）保護のため config.toml のみ
    ".config/herdr/config.toml".source = link "${dots}/.config/herdr/config.toml";

    # git identity（実際のメールアドレス等）は .gitignore 済みの実体を symlink するだけ。
    # mkOutOfStoreSymlink はパス文字列を張るだけで中身を読まないため、
    # 未追跡ファイルでも問題なく参照できる（初回のみ手動で中身を作成する）。
    ".config/git/identity.gitconfig".source = link "${dots}/.config/git/identity.gitconfig";
    ".config/git/identity-personal.gitconfig".source = link "${dots}/.config/git/identity-personal.gitconfig";
  };
  # ghostty は programs.ghostty（home/ghostty.nix）で完全Nix管理

  # 管理対象外（意図的に除外）:
  # - yazi（棚卸しで削除したツール）
  # - wezterm（未使用。ghostty へ移行済み）
  # - ccstatusline（~/.config に別実体があるため上書き回避）
}
