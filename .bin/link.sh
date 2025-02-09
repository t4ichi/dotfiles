#!/bin/bash
DOTFILES_DIR="$(pwd)"

for file in "$DOTFILES_DIR"/.*; do
  base="$(basename "$file")"

  # Skip current and parent directories and ignored files
  if [[ "$base" == "." || "$base" == ".." || "$base" == ".git" || "$base" == ".gitignore" || "$base" == ".DS_Store" ]]; then
    continue
  fi

  # Define the destination path
  target="$HOME/$base"

  # Check if the target already exists
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "Skipping $target: already exists."
  else
    echo "Creating symbolic link for $base in $HOME."
    ln -s "$file" "$target"
  fi
done

# Handle .config directory separately
config_dir="$DOTFILES_DIR/.config"
if [ -d "$config_dir" ]; then
  for config_file in "$config_dir"/*; do
    config_base="$(basename "$config_file")"
    config_target="$HOME/.config/$config_base"

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Check if the target already exists
    if [ -e "$config_target" ] || [ -L "$config_target" ]; then
      echo "Skipping $config_target: already exists."
    else
      echo "Creating symbolic link for $config_base in $HOME/.config."
      ln -s "$config_file" "$config_target"
    fi
  done
fi
