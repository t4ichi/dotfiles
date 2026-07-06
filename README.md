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

# 責務ベースの構成（浅い階層=抽象、具体は配下）
```
flake.nix / flake.lock  # 構築の根
bootstrap.sh            # Nix 導入前の手続き的ブートストラップ
system/                 # OS/マシン面: Homebrew(apps) / fonts / macOS defaults
user/                   # home-manager: packages / shell / symlinks(配置写像) / claude 導入
tools/                  # 個別ツール設定: nvim / ghostty / herdr / mise / git / vscode
secrets/                # マシン固有の秘匿値（雛形 + .gitignore 実体）
.claude/                # Claude Code のプロジェクト設定（規約上ルート固定・特別扱い）
```

- 配置先（`~/.config` 等）は `user/symlinks.nix` が一手に管理。ソースの
  ディレクトリ名はデプロイ先を知らない（責務で分割）。
- CLI/フォントは Nix、GUI アプリは Homebrew(cask) を nix-darwin から宣言管理。
- tools/* はリポジトリ実体への symlink 管理（直接編集で即反映）。
- vscode は programs.vscode、zsh(starship) は Nix 生成。
