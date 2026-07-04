# dotfiles の Nix 化（nix-darwin + home-manager）設計

- 日付: 2026-07-04
- 対象リポジトリ: `~/dotfiles`
- ステータス: 設計承認済み（実装計画へ移行前）

## 1. 背景と目的

現在の dotfiles は **Make ベースの手続き型**で管理されている。

- `make` → `init`(Homebrew/oh-my-zsh/tpm 導入) → `brew`(`brew bundle --global`) → `defaults`(macOS 設定) → `link`(symlink 配布)
- `.Brewfile`: tap×3 / brew×40 / cask×13
- 各種設定は `.bin/link.sh` により symlink で配布

**目的（ユーザー確定）**: パッケージ・dotfiles・macOS 設定を**全て宣言的にコード化**し、手続き型 script を減らす。副次目標として新マシンの再現構築とバージョン固定。

## 2. 全体アーキテクチャ

1 つの **flake** で macOS 全体を宣言的に管理する。**nix-darwin + home-manager** を採用。

```
~/dotfiles/
├── flake.nix           # inputs(nixpkgs / nix-darwin / home-manager) と構成の入口
├── flake.lock          # バージョン固定（再現性の要）
├── darwin/
│   └── default.nix     # システム: nix 設定 / Homebrew(casks/taps) / macOS defaults
├── home/
│   ├── default.nix     # home-manager 入口
│   ├── packages.nix    # CLI ツール(Nix パッケージ)
│   ├── zsh.nix         # zsh + starship + プラグイン
│   └── dotfiles.nix    # 設定ファイルのリンク管理
├── config/ (既存の .config 等)  # 中身はそのまま、home 側から参照
└── bootstrap.sh        # Nix 本体と xcode CLT の最小導入（ここだけ手続き型に残す）
```

- 適用コマンドは **`darwin-rebuild switch --flake ~/dotfiles`** に一本化する。
- `make switch` などの薄いラッパー（`darwin-rebuild` を呼ぶだけ）は任意で残してよい。
- Nix インストーラは Determinate Systems 版（flakes 既定 ON・アンインストール容易）を想定。
- Homebrew は nix-darwin の組み込み `homebrew` モジュールで宣言的に扱う（Homebrew 本体は bootstrap で導入済みを前提）。

## 3. パッケージの振り分け

現状 40 formulae / 13 cask を以下の方針で振り分ける。

| 種類 | 移行先 | 例 |
|------|--------|----|
| CLI ツール | **Nix パッケージ**（home-manager `home.packages`） | git, gh, neovim, tmux, ripgrep, fzf, lazygit, lazydocker, go, rust, node, pnpm, yazi, zoxide, uv, tree, wget, curl, ffmpeg, imagemagick, cmake, gcc, lua, luarocks, protobuf, mpv, genact, neofetch, duktape, lefthook, posting 等 |
| GUI アプリ・フォント(cask) | **nix-darwin `homebrew.casks`**（宣言的） | arc, slack, notion, obsidian, docker, visual-studio-code, ghostty, raycast, postman, gimp, deepl, font-jetbrains-mono-nerd-font, font-sf-mono |
| サービス/tap 系 | **homebrew モジュールに残す** | ollama(`restart_service`), supabase(`supabase/tap`) |
| バージョン管理 | **当面そのまま維持（今回スコープ外）** | nvm, pyenv, python@3.10 |

- zsh 関連 brew（powerlevel10k / zsh-autosuggestions / zsh-syntax-highlighting / zsh）は §4 で置き換えるため**廃止**。
- 将来課題（スコープ外）: nvm/pyenv を Nix devshell / per-project flake へ移行。

## 4. シェル（zsh 継続・最新化）

home-manager の `programs.zsh` で宣言的に構成する。

- **starship** を導入（プロンプト）。`starship.toml` も宣言管理。
- **oh-my-zsh を廃止**。
- **powerlevel10k を廃止**（starship で代替）。
- autosuggestions / syntax-highlighting は home-manager ネイティブ機能で維持
  （`programs.zsh.autosuggestion.enable` / `syntaxHighlighting.enable`）。
- 現 `.zshrc` の中身（alias, PATH 追加, nvm 読み込み, mysql-client / vite-plus / devcontainers の PATH 等）を home-manager 側（`initExtra` 等）へ移植。

## 5. dotfiles の管理

現在の `.bin/link.sh`（symlink 配布）を home-manager に置き換える。

- 頻繁に編集する設定（nvim / herdr / ghostty / tmux 等）は **`config.lib.file.mkOutOfStoreSymlink`** を用い、**リポジトリを直接編集 → 即反映**の現行の使い勝手を維持したまま宣言的に管理する（編集ごとの rebuild を不要にする）。
- herdr は `config.toml` のみをリンクする現行方針（ランタイムファイル保護）を踏襲する。

## 6. macOS 設定

`.bin/defaults.sh` の内容を nix-darwin の `system.defaults` へ移植し、宣言的に管理する。

## 7. bootstrap（唯一残す手続き型）

Nix 自体は Nix で入れられないため、最小のブートストラップのみ手続き型で残す。

- xcode Command Line Tools の導入確認
- Nix（Determinate Systems installer）の導入
- Homebrew 本体の導入（`homebrew` モジュールが前提とするため）
- 以降は `darwin-rebuild switch --flake ~/dotfiles` に委ねる

oh-my-zsh の導入は廃止。tpm（tmux plugin manager）は当面現行踏襲（将来 home-manager `programs.tmux.plugins` へ移行可）。

## 8. 段階的移行フェーズ

各フェーズは単独で検証・ロールバック可能。旧 `make` 系は最後まで動く状態を維持する。

1. **土台**: Nix 導入 → 最小 flake（nix-darwin + home-manager）が `darwin-rebuild switch` で通ることを確認。
2. **パッケージ**: CLI → Nix / casks → homebrew モジュール / ollama・supabase を homebrew に残す。パリティ確認後に `.Brewfile`・`.bin/brew.sh` を削除。
3. **シェル**: zsh + starship 化、oh-my-zsh / powerlevel10k 廃止、`.zshrc` 移植。
4. **dotfiles**: home-manager 化（`mkOutOfStoreSymlink`）、`.bin/link.sh` 廃止。
5. **macOS 設定**: `.bin/defaults.sh` → `system.defaults`。
6. **後片付け**: `Makefile`・`.bin`（bootstrap を除く）・`.Brewfile` 撤去、README 更新。残るのは `bootstrap.sh` + flake のみ。

## 9. スコープ外（今回やらないこと）

- nvm / pyenv / python@3.10 の Nix 化（当面維持）。
- tpm の home-manager 化（当面維持）。
- vscode 拡張（`.bin/vscode.sh`）の Nix 化 ※必要なら後日フェーズ追加。
- Linux / 非 macOS 対応（macOS 専用構成とする）。

## 10. 成功基準

- `darwin-rebuild switch --flake ~/dotfiles` 一発で、パッケージ・casks・シェル・dotfiles・macOS 設定が適用される。
- 旧 `.Brewfile` / `.bin`（bootstrap 除く）/ `Makefile` が撤去され、宣言的構成に一本化されている。
- starship プロンプトが表示され、oh-my-zsh / powerlevel10k に依存しない。
- 既存の設定ファイル群がリポジトリ直接編集で反映される（現行の使い勝手維持）。
