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

# 機構分離の構成（nix の宣言 と 設定ペイロード を分ける）
```
flake.nix / flake.lock  # 構築の根
bootstrap.sh            # Nix 導入前の手続き的ブートストラップ
nix/                    # Nix の宣言（“どう組み上げるか”）
  darwin/               #   nix-darwin: Homebrew(apps) / fonts / macOS defaults
  home/                 #   home-manager: packages / shell / git / vscode / claude 導入 / symlinks
config/                 # 設定ペイロード（アプリが実行時に読む実ファイル）: nvim / ghostty / herdr / mise
secrets/                # マシン固有の秘匿値（雛形 + .gitignore 実体）: git / zsh
.claude/                # Claude Code のプロジェクト設定（規約上ルート固定・特別扱い）
```

- 配置先（`~/.config` 等）は `nix/home/symlinks.nix` が一手に管理。ソースの
  ディレクトリ名（config/ 等）はデプロイ先の事情（先頭ドット等）を持たない。
- CLI/フォントは Nix、GUI アプリは Homebrew(cask) を nix-darwin から宣言管理。
- config/* はリポジトリ実体への symlink 管理（直接編集で即反映）。
- vscode は programs.vscode、zsh(starship) は Nix 生成。
