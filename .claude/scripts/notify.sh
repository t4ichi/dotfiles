#!/bin/bash
# tmux + Ghostty 向け Claude Code 完了通知

SESSION_DIR=$(basename "$(pwd)")
MSG="✅ Claude Code: $SESSION_DIR タスク完了"

# --- tmux のステータスバーに表示 ---
if [ -n "$TMUX" ]; then
  tmux display-message "$MSG"
fi

# --- tmux のベル（視覚/音声アラート）を鳴らす ---
# tmuxのactivity monitorが有効なら他ペインでも検知できる
printf '\a'

# --- macOS の場合はシステム通知も送る ---
if [[ "$(uname)" == "Darwin" ]]; then
  osascript -e "display notification \"$SESSION_DIR\" with title \"Claude Code 完了\" sound name \"Glass\""
fi
