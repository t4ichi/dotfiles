# dotfiles

macOS (Apple Silicon) 向け。**nix-darwin + home-manager** で宣言的に管理しています。

## Setup（新しいマシン）

```sh
git clone https://github.com/t4ichi/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Nix / Command Line Tools / Homebrew の最小ブートストラップ
./bootstrap.sh

# git のユーザー名/メールアドレスは公開リポジトリに含めないため、
# .config/git/*.gitconfig は .gitignore 済み。マシンごとに手動で1回作成する
# （home/dotfiles.nix が ~/.config/git/ へ自動で symlink する）
cp .config/git/identity.gitconfig.example .config/git/identity.gitconfig
cp .config/git/identity-personal.gitconfig.example .config/git/identity-personal.gitconfig
# ↑ 2ファイルとも中身を実際の name/email に書き換える
#   identity.gitconfig          既定値（マシンごとに会社/個人を書き分ける）
#   identity-personal.gitconfig ~/dotfiles 配下だけ強制的にこちらが使われる

# 社内プロキシ等マシン固有の値も同様（不要なマシンでは作成しなくてOK）
cp .config/zsh/proxy.env.example .config/zsh/proxy.env
# ↑ 中身を実際のプロキシURL等に書き換える（無ければ何もexportされない）

# 初回適用（darwin-rebuild がまだ PATH に無いため flake 経由）
sudo nix run nix-darwin -- switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
```

## 以後の適用

```sh
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
```

## 構成

```
flake.nix          # 入口（nixpkgs / nix-darwin / home-manager）
darwin/default.nix # システム: Homebrew(casks) / fonts / macOS defaults
home/              # home-manager: パッケージ / zsh+starship / vscode / dotfiles / git
.config/           # ~/.config へ symlink する設定（nvim / ghostty / mise 等）
bootstrap.sh       # Nix 導入前の最小ブートストラップ（唯一の手続き型）
```

- パッケージは Nix、GUI アプリ（cask）は Homebrew を nix-darwin から宣言管理。
- nvim / herdr / .claude はリポジトリ実体への symlink 管理（直接編集で即反映）。
- ghostty / zsh(starship) は完全に Nix 生成。
