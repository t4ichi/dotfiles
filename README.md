# dotfiles

Make a backup of your current Neovim files:
```sh
# required
rsync -av --progress ~/.config/nvim ~/.config/nvim.bak --exclude nvim.bak

# optional but recommended
rsync -av --progress ~/.local/share/nvim ~/.local/share/nvim.bak --exclude nvim.bak
rsync -av --progress ~/.local/state/nvim ~/.local/state/nvim.bak --exclude nvim.bak
rsync -av --progress ~/.cache/nvim ~/.cache/nvim.bak --exclude nvim.bak
```

Clone the repository and create symbolic links:
```sh
git clone https://github.com/t4ichi/dotfiles.git ~/dotfiles

# Create symbolic links
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.local/share/nvim ~/.local/share/nvim
ln -s ~/dotfiles/.local/state/nvim ~/.local/state/nvim
ln -s ~/dotfiles/.cache/nvim ~/.cache/nvim
