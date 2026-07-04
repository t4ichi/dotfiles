#!/bin/bash
# Nix 移行に伴う Homebrew の棚卸しスクリプト（冪等）
#
# 目的:
#   - Nix へ移行したパッケージの Homebrew 版を削除（重複解消）
#   - 使わなくなったパッケージを削除
#
# 使い方:
#   ./scripts/cleanup-legacy-brew.sh          # 何が消えるか表示して確認プロンプト
#   ./scripts/cleanup-legacy-brew.sh --yes     # 確認なしで実行
#
# 安全設計: インストール済みのものだけ対象にする。未インストールはスキップ。

set -uo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew が見つかりません。何もしません。"
  exit 0
fi

# --- 削除対象 ---------------------------------------------------------------

# Nix へ移行したため Homebrew 版が不要になったもの
MIGRATED_FORMULAE=(herdr)
MIGRATED_CASKS=(ghostty font-jetbrains-mono-nerd-font)

# 棚卸しで使わないと判断したもの
UNUSED_FORMULAE=(ollama supabase pyenv python@3.10)
UNUSED_CASKS=(notion gimp deepl font-sf-mono)

# 削除するタップ
LEGACY_TAPS=(supabase/tap)

# ---------------------------------------------------------------------------

AUTO_YES=0
[ "${1:-}" = "--yes" ] && AUTO_YES=1

installed_formulae() { brew list --formula -1 2>/dev/null; }
installed_casks() { brew list --cask -1 2>/dev/null; }
installed_taps() { brew tap 2>/dev/null; }

# $1=対象名 $2=リスト(改行区切り) -> インストール済みなら 0
is_in() { printf '%s\n' "$2" | grep -qxF "$1"; }

FORMULA_LIST="$(installed_formulae)"
CASK_LIST="$(installed_casks)"
TAP_LIST="$(installed_taps)"

to_remove_formulae=()
for f in "${MIGRATED_FORMULAE[@]}" "${UNUSED_FORMULAE[@]}"; do
  is_in "$f" "$FORMULA_LIST" && to_remove_formulae+=("$f")
done

to_remove_casks=()
for c in "${MIGRATED_CASKS[@]}" "${UNUSED_CASKS[@]}"; do
  is_in "$c" "$CASK_LIST" && to_remove_casks+=("$c")
done

to_remove_taps=()
for t in "${LEGACY_TAPS[@]}"; do
  is_in "$t" "$TAP_LIST" && to_remove_taps+=("$t")
done

if [ ${#to_remove_formulae[@]} -eq 0 ] && [ ${#to_remove_casks[@]} -eq 0 ] && [ ${#to_remove_taps[@]} -eq 0 ]; then
  echo "削除対象はありません（すでにクリーンです）。"
  exit 0
fi

echo "以下を削除します:"
[ ${#to_remove_formulae[@]} -gt 0 ] && echo "  formulae: ${to_remove_formulae[*]}"
[ ${#to_remove_casks[@]} -gt 0 ] && echo "  casks:    ${to_remove_casks[*]}"
[ ${#to_remove_taps[@]} -gt 0 ] && echo "  taps:     ${to_remove_taps[*]}"
echo

if [ "$AUTO_YES" -ne 1 ]; then
  printf "実行しますか? [y/N] "
  read -r ans
  case "$ans" in
    [yY]|[yY][eE][sS]) ;;
    *) echo "中止しました。"; exit 0 ;;
  esac
fi

[ ${#to_remove_formulae[@]} -gt 0 ] && brew uninstall "${to_remove_formulae[@]}"
[ ${#to_remove_casks[@]} -gt 0 ] && brew uninstall --cask "${to_remove_casks[@]}"
for t in "${to_remove_taps[@]}"; do brew untap "$t"; done

echo "完了しました。"
