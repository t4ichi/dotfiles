{ pkgs, ... }:
{
  # user.name / user.email はここでは一切管理しない（公開リポジトリのため）。
  # 実体は secrets/git/identity-<name>.gitconfig（gitignore、雛形は *.example）に置き、
  # アクティブな 1 つを ~/.config/git/identity-active.gitconfig へ symlink して切り替える。
  # 切り替えは `git-identity <name>`（下記スクリプト）で行う。
  programs.git = {
    enable = true;
    settings.include.path = "~/.config/git/identity-active.gitconfig";
  };

  # git-identity: アクティブな identity を任意に切り替えるツール
  #   git-identity            現在のアクティブ + 候補一覧
  #   git-identity <name>     secrets/git/identity-<name>.gitconfig をアクティブに
  home.packages = [
    (pkgs.writeShellScriptBin "git-identity" ''
      set -euo pipefail
      dir="$HOME/.config/git"
      src="$HOME/dotfiles/secrets/git"
      active="$dir/identity-active.gitconfig"

      list() {
        for f in "$src"/identity-*.gitconfig; do
          [ -e "$f" ] || continue
          name=$(basename "$f" .gitconfig); name=''${name#identity-}
          printf '  %-10s %s\n' "$name" "$(${pkgs.git}/bin/git config -f "$f" user.email 2>/dev/null || true)"
        done
      }

      if [ $# -eq 0 ]; then
        cur=$(readlink "$active" 2>/dev/null || true)
        echo "current: ''${cur:-(none)}"
        echo "available:"
        list
        exit 0
      fi

      target="$src/identity-$1.gitconfig"
      if [ ! -f "$target" ]; then
        echo "identity '$1' not found. available:" >&2
        list >&2
        exit 1
      fi
      mkdir -p "$dir"
      ln -sf "$target" "$active"
      echo "switched to '$1' ($(${pkgs.git}/bin/git config -f "$target" user.email 2>/dev/null || true))"
    '')
  ];
}
