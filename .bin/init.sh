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

