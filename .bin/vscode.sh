#!/bin/bash

# Define the source and target paths
declare -A FILES_TO_LINK=(
  ["$HOME/dotfiles/vscode/settings.json"]="$HOME/Library/Application Support/Code/User/settings.json"
  ["$HOME/dotfiles/vscode/keybindings.json"]="$HOME/Library/Application Support/Code/User/keybindings.json"
)

# Create directories and symbolic links
for SOURCE in "${!FILES_TO_LINK[@]}"; do
  TARGET="${FILES_TO_LINK[$SOURCE]}"
  mkdir -p "$(dirname "$TARGET")"
  ln -sf "$SOURCE" "$TARGET"
done

echo "VSCode Symbolic links created successfully."
