#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is for macOS (Darwin) only."
  exit 1
fi

# Check if Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Initiating installation..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi
