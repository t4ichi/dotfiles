#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS (Darwin) only."
  exit 1
fi

# Check if xcode-select is installed
if ! xcode-select -p >/dev/null 2>&1; then
  echo "xcode-select not found. Installing Command Line Tools..."
  xcode-select --install
else
  echo "xcode-select is already installed."
fi

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Initiating installation..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Check if oh-my-zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh not found. Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "oh-my-zsh is already installed."


# Check if tmux plugin manager is installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "tmux plugin manager not found. Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "tmux plugin manager is already installed."
fi
