# dotfiles

Make a backup of your current Neovim files:
```
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```

Clone the repository and move the files to the correct location:
```
git clone https://github.com/t4ichi/dotfiles.git
mv -f ~/dotfiles/.* ~/tmp
mv -f ~/dotfiles/* ~/tmp
rm -rf ~/dotfiles
```

