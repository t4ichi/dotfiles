# dotfiles

macOS (Apple Silicon) 向け。nix-darwin + home-manager で管理。

## Setup

```sh
git clone https://github.com/t4ichi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh   # Nix / CLT / Homebrew

# 秘匿値はマシンごとに手動作成（.example をコピーして中身を書き換え）
cp secrets/git/identity.gitconfig.example       secrets/git/identity.gitconfig
cp secrets/git/identity-personal.gitconfig.example secrets/git/identity-personal.gitconfig
cp secrets/zsh/proxy.env.example                secrets/zsh/proxy.env   # 不要なら省略可

sudo nix run nix-darwin -- switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
```

以後: `darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"`

## 構成

```
nix/      # Nix 宣言（darwin=システム / home=home-manager）
config/   # 設定ペイロード（nvim / ghostty / herdr / mise）
secrets/  # 秘匿値（gitignore + .example 雛形）
.claude/  # Claude Code プロジェクト設定
```
配置先は `nix/home/symlinks.nix` が管理。
