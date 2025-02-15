#!/bin/bash

# Define the source and target paths for settings and keybindings
SETTINGS_SOURCE_PATH="$HOME/dotfiles/vscode/settings.json"
SETTINGS_TARGET_PATH="$HOME/Library/Application Support/Code/User/settings.json"
KEYBINDINGS_SOURCE_PATH="$HOME/dotfiles/vscode/keybindings.json"
KEYBINDINGS_TARGET_PATH="$HOME/Library/Application Support/Code/User/keybindings.json"

# Create symbolic links for VSCode settings and keybindings
ln -sf "$SETTINGS_SOURCE_PATH" "$SETTINGS_TARGET_PATH"
ln -sf "$KEYBINDINGS_SOURCE_PATH" "$KEYBINDINGS_TARGET_PATH"

echo "VSCode Symbolic links created successfully."

# Install VSCode extensions
echo "Installing extensions..."
code --install-extension vscodevim.vim

echo "VSCode extensions installed successfully."
