#!/bin/bash
# Nix 化後の唯一の手続き型ブートストラップ（新マシン初期化用）
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macOS 専用です。"
  exit 1
fi

# xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Command Line Tools をインストールします..."
  xcode-select --install
  echo "インストール完了後に再実行してください。"
  exit 0
fi

# Nix (Determinate Systems installer, flakes 既定 ON)
if ! command -v nix >/dev/null 2>&1; then
  echo "Nix をインストールします..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  echo "新しいシェルを開いてから再実行してください（PATH 反映のため）。"
  exit 0
fi

# Homebrew 本体（homebrew モジュールが前提とする）
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew をインストールします..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# tmux plugin manager（tmux.conf が参照）
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "tmux plugin manager をインストールします..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo ""
echo "Bootstrap 完了。次を実行してください:"
echo "  sudo nix run nix-darwin -- switch --flake ~/dotfiles#$(scutil --get LocalHostName)"
echo "以後の適用:"
echo "  darwin-rebuild switch --flake ~/dotfiles#$(scutil --get LocalHostName)"
