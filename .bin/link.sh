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

# Handle .claude/settings.json separately
claude_settings="$DOTFILES_DIR/.claude/settings.json"
if [ -f "$claude_settings" ]; then
  mkdir -p "$HOME/.claude"
  claude_target="$HOME/.claude/settings.json"
  if [ -L "$claude_target" ]; then
    echo "Skipping $claude_target: symlink already exists."
  elif [ -f "$claude_target" ]; then
    echo "Backing up existing $claude_target to $claude_target.bak"
    mv "$claude_target" "$claude_target.bak"
    echo "Creating symbolic link for .claude/settings.json in $HOME/.claude."
    ln -s "$claude_settings" "$claude_target"
  else
    echo "Creating symbolic link for .claude/settings.json in $HOME/.claude."
    ln -s "$claude_settings" "$claude_target"
  fi
fi

# Handle .claude/skills directory separately
claude_skills="$DOTFILES_DIR/.claude/skills"
if [ -d "$claude_skills" ]; then
  mkdir -p "$HOME/.claude"
  skills_target="$HOME/.claude/skills"
  if [ -L "$skills_target" ]; then
    echo "Skipping $skills_target: symlink already exists."
  elif [ -d "$skills_target" ]; then
    echo "Backing up existing $skills_target to $skills_target.bak"
    mv "$skills_target" "$skills_target.bak"
    echo "Creating symbolic link for .claude/skills in $HOME/.claude."
    ln -s "$claude_skills" "$skills_target"
  else
    echo "Creating symbolic link for .claude/skills in $HOME/.claude."
    ln -s "$claude_skills" "$skills_target"
  fi
fi

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
