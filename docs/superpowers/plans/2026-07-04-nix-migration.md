# dotfiles Nix 化 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** dotfiles のパッケージ・シェル・dotfiles・macOS 設定を nix-darwin + home-manager の 1 flake で宣言的に管理し、`darwin-rebuild switch` に一本化する。

**Architecture:** 1 つの flake（`flake.nix`）が nix-darwin と home-manager を束ねる。システム層（nix 設定 / Homebrew casks / macOS defaults）は `darwin/default.nix`、ユーザ層（CLI パッケージ / zsh / dotfiles）は `home/*.nix`。GUI アプリは Homebrew を nix-darwin の `homebrew` モジュールで宣言的に管理。移行は 6 フェーズで段階的に行い、各フェーズ完了まで旧 `make`/`.bin`/`.Brewfile` は動作する状態を維持する。

**Tech Stack:** Nix (flakes), nix-darwin, home-manager, Homebrew(宣言管理), zsh, starship

## Global Constraints

- 対象は **macOS / Apple Silicon (`aarch64-darwin`)** 専用。`uname -m` が `arm64` であることを前提とする。
- **各タスクの「テスト」= `darwin-rebuild build --flake .#<host>` が成功すること + 記載の挙動確認コマンドが期待結果を返すこと。** ビルドが通らなければ次へ進まない。
- nix-darwin / home-manager の**オプション名はバージョンで変わる**。ビルドがオプション未知でエラーした場合は該当マニュアル（nix-darwin manual / home-manager options）を確認して修正する。ビルド検証がその安全網。
- **コミットに `Co-Authored-By: Claude` 等の署名を付けない**（ユーザー方針）。コミットメッセージは日本語、ファイルは UTF-8。
- 各フェーズのパリティ確認が済むまで、旧 `Makefile` / `.bin/*` / `.Brewfile` は削除しない。
- `<host>` はフラグメント名。`scutil --get LocalHostName` の値を使う。`<user>` = `taichiitou`。

---

## File Structure

- `flake.nix` — inputs と `darwinConfigurations.<host>` の定義（入口）
- `darwin/default.nix` — システム設定: nix 設定 / `homebrew`(casks/taps/brews) / `system.defaults`
- `home/default.nix` — home-manager 入口。他 `home/*.nix` を import
- `home/packages.nix` — CLI ツール（Nix パッケージ）
- `home/zsh.nix` — zsh + starship + autosuggestion + syntax-highlighting
- `home/dotfiles.nix` — 設定ファイルの `mkOutOfStoreSymlink` 管理
- `bootstrap.sh` — Nix / xcode CLT / Homebrew の最小導入（唯一の手続き型）
- 撤去対象（フェーズ6）: `Makefile`, `.bin/{init,brew,defaults,link}.sh`, `.Brewfile`

---

## Phase 1: 土台

### Task 1: 最小 flake が `darwin-rebuild switch` で通る

**Files:**
- Create: `flake.nix`
- Create: `darwin/default.nix`
- Create: `home/default.nix`
- Create: `bootstrap.sh`

**Interfaces:**
- Produces: `darwinConfigurations.<host>`（後続タスクが `darwin/` と `home/` を拡張していく土台）

- [ ] **Step 1: 前提確認（Nix 導入）**

Nix 未導入なら Determinate Systems installer で導入する。導入済みならスキップ。

Run:
```bash
uname -m   # arm64 であること
nix --version 2>/dev/null || curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
Expected: `nix --version` がバージョンを表示（flakes 有効）。

- [ ] **Step 2: `bootstrap.sh` を作成**

```bash
#!/bin/bash
# Nix 化後の唯一の手続き型ブートストラップ（新マシン初期化用）
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then echo "macOS 専用"; exit 1; fi

# xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Command Line Tools..."; xcode-select --install
fi

# Nix (Determinate Systems installer, flakes 既定 ON)
if ! command -v nix >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

# Homebrew 本体（homebrew モジュールが前提とする）
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Bootstrap 完了。次を実行: darwin-rebuild switch --flake ~/dotfiles"
```

- [ ] **Step 3: `flake.nix` を作成**

`<host>` は実際の `scutil --get LocalHostName` の値に置き換える。

```nix
{
  description = "taichi's macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, nix-darwin, home-manager }:
  let
    username = "taichiitou";
    system = "aarch64-darwin";
  in {
    darwinConfigurations."<host>" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = [
        ./darwin/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = import ./home/default.nix;
          home-manager.extraSpecialArgs = { inherit inputs username; };
        }
      ];
    };
  };
}
```

- [ ] **Step 4: `darwin/default.nix` を作成（最小）**

```nix
{ pkgs, username, ... }:
{
  # 対象ユーザ（home-manager 連携に必要）
  users.users.${username}.home = "/Users/${username}";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 変更しない限り上げないこと（初回のみ設定）
  system.stateVersion = 5;

  # 後続フェーズで homebrew / system.defaults を追記する
}
```

- [ ] **Step 5: `home/default.nix` を作成（最小）**

```nix
{ username, ... }:
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";  # 初回固定。以後変更しない
  programs.home-manager.enable = true;

  # 後続フェーズで packages / zsh / dotfiles を import する
}
```

- [ ] **Step 6: ビルド検証（テスト）**

Run:
```bash
cd ~/dotfiles
nix flake check 2>&1 | tail -5 || true
darwin-rebuild build --flake .#"$(scutil --get LocalHostName)"
```
Expected: エラーなくビルド成功（`result` シンボリックリンク生成）。失敗時はオプション名・host 名を修正。

- [ ] **Step 7: 適用（初回 switch）**

初回は `darwin-rebuild` が未 PATH の場合があるため flake 経由で実行。

Run:
```bash
sudo nix run nix-darwin -- switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
# 2 回目以降は: darwin-rebuild switch --flake ~/dotfiles#<host>
```
Expected: `switch` 成功。新シェルで `darwin-rebuild --help` が通る。

- [ ] **Step 8: Commit**

```bash
chmod +x bootstrap.sh
git add flake.nix flake.lock darwin/default.nix home/default.nix bootstrap.sh
git commit -m "feat: nix-darwin + home-manager の最小flakeを追加（Phase1 土台）"
```

---

## Phase 2: パッケージ

### Task 2: CLI ツールを Nix パッケージへ

**Files:**
- Create: `home/packages.nix`
- Modify: `home/default.nix`（import 追加）

**Interfaces:**
- Consumes: `home/default.nix` の home-manager 構成
- Produces: `home.packages`（CLI ツール群）

- [ ] **Step 1: `home/packages.nix` を作成**

nixpkgs 名は `nix search nixpkgs <name>` で確認可能。不明分はビルドエラーで判明する。

```nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git gh
    neovim tmux
    ripgrep fzf tree
    lazygit lazydocker lefthook
    go rustup nodejs pnpm
    yazi zoxide uv
    wget curl
    ffmpeg imagemagick mpv
    cmake gcc lua luarocks protobuf
    genact fastfetch duktape
    posting
  ];
}
```
補足: `node`→`nodejs`、`neofetch`→`fastfetch`（neofetch は開発終了）、`rust`→`rustup`。`powerlevel10k` / `zsh-autosuggestions` / `zsh-syntax-highlighting` / `zsh` は Phase 3 で扱うため含めない。`nvm` / `pyenv` / `python@3.10` はスコープ外（Homebrew に残す）。

- [ ] **Step 2: `home/default.nix` に import を追加**

```nix
{ username, ... }:
{
  imports = [ ./packages.nix ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
```

- [ ] **Step 3: ビルド検証（テスト）**

Run:
```bash
cd ~/dotfiles
darwin-rebuild build --flake .#"$(scutil --get LocalHostName)"
```
Expected: 成功。未知パッケージ名があればエラー行の名前を `nix search nixpkgs` で修正。

- [ ] **Step 4: 適用と存在確認**

Run:
```bash
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
for t in git gh nvim tmux rg fzf lazygit go node pnpm yazi zoxide uv; do
  command -v "$t" >/dev/null && echo "OK $t" || echo "MISS $t"; done
```
Expected: 主要ツールが `OK`（Nix 由来 `/etc/profiles/...` or `~/.nix-profile`）。

- [ ] **Step 5: Commit**

```bash
git add home/packages.nix home/default.nix flake.lock
git commit -m "feat: CLIツールをNixパッケージへ移行（Phase2）"
```

### Task 3: casks / taps / サービスを homebrew モジュールへ

**Files:**
- Modify: `darwin/default.nix`（`homebrew` ブロック追加）

**Interfaces:**
- Consumes: Homebrew 本体（bootstrap 導入済み）
- Produces: `homebrew.casks` / `homebrew.brews` / `homebrew.taps`

- [ ] **Step 1: `darwin/default.nix` に homebrew ブロックを追加**

`system.stateVersion` 行の下に追記。

```nix
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";   # 宣言外の brew/cask を掃除
    };
    taps = [ "supabase/tap" ];
    brews = [
      { name = "ollama"; restart_service = true; }
      "supabase"
      # スコープ外だが当面維持:
      "nvm"
      "pyenv"
      "python@3.10"
    ];
    casks = [
      "arc" "slack" "notion" "obsidian"
      "docker" "visual-studio-code" "postman"
      "ghostty" "raycast" "gimp" "deepl"
      "font-jetbrains-mono-nerd-font" "font-sf-mono"
    ];
  };
```

- [ ] **Step 2: ビルド検証（テスト）**

Run:
```bash
cd ~/dotfiles
darwin-rebuild build --flake .#"$(scutil --get LocalHostName)"
```
Expected: 成功。`cleanup = "zap"` の意味（宣言外を削除）を理解した上で進む。

- [ ] **Step 3: 適用と確認**

Run:
```bash
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
brew list --cask | grep -E 'arc|slack|ghostty|raycast' || true
brew services list | grep ollama || true
```
Expected: casks が揃い、ollama サービスが動作。

- [ ] **Step 4: Commit**

```bash
git add darwin/default.nix
git commit -m "feat: casks/taps/サービスをhomebrewモジュールで宣言管理（Phase2）"
```

### Task 4: 旧 Brewfile 経路を撤去

**Files:**
- Delete: `.Brewfile`
- Delete: `.bin/brew.sh`
- Modify: `Makefile`（`brew` ターゲットと `all` 依存から除去）

- [ ] **Step 1: パリティ最終確認**

Run:
```bash
comm -23 <(grep -E '^(brew|cask) ' ~/dotfiles/.Brewfile | awk '{print $2}' | tr -d '"' | sort -u) \
         <(brew list --formula -1; brew list --cask -1 | sort -u) | sed '/^$/d'
```
Expected: 出力が空（＝ Brewfile の全項目が導入済み）。差分があれば Task 2/3 に戻して補う。

- [ ] **Step 2: 削除と Makefile 修正**

`Makefile` の `all:` 行から `brew` を除去し、`brew:` ターゲット定義ブロックを削除する。

Run:
```bash
cd ~/dotfiles
git rm .Brewfile .bin/brew.sh
```
その後 `Makefile` を編集（`all: init brew defaults link` → `all: init defaults link`、`brew:` ブロック削除）。

- [ ] **Step 3: 検証**

Run: `grep -n brew Makefile || echo "brew参照なし"`
Expected: `brew参照なし`。

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "chore: Brewfile/brew.sh経路を撤去しhomebrewモジュールへ一本化（Phase2）"
```

---

## Phase 3: シェル（zsh + starship）

### Task 5: zsh を home-manager 化し starship 導入・oh-my-zsh/p10k 廃止

**Files:**
- Create: `home/zsh.nix`
- Modify: `home/default.nix`（import 追加）
- Modify: `.zshrc`（後に撤去。内容は zsh.nix へ移植）

**Interfaces:**
- Consumes: home-manager 構成
- Produces: `programs.zsh` / `programs.starship` / `programs.zoxide` / `programs.fzf`

- [ ] **Step 1: 現 `.zshrc` の内容を確認して移植対象を洗い出す**

Run: `cat ~/dotfiles/.zshrc`
Expected: alias（`yz=yazi` 等）、NVM 読み込み、mysql-client / vite-plus / devcontainers の PATH を把握。

- [ ] **Step 2: `home/zsh.nix` を作成**

現 `.zshrc` の alias / PATH / nvm 読み込みを `initExtra` に移植する。

```nix
{ ... }:
{
  programs.starship.enable = true;

  programs.zoxide = { enable = true; enableZshIntegration = true; };
  programs.fzf = { enable = true; enableZshIntegration = true; };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      yz = "yazi";
    };

    # 旧 .zshrc から移植（oh-my-zsh / powerlevel10k は使わない）
    initExtra = ''
      # nvm
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

      # mysql-client
      export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

      # Vite+ bin
      [ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

      # devcontainers
      export PATH="$HOME/.devcontainers/bin:$PATH"
    '';
  };
}
```
補足: starship 設定を凝る場合は `programs.starship.settings` を追加。既存の `~/.config/starship.toml` を使うなら Phase 4 の dotfiles 管理に含める。

- [ ] **Step 3: `home/default.nix` に import 追加**

```nix
  imports = [ ./packages.nix ./zsh.nix ];
```

- [ ] **Step 4: ビルド検証（テスト）**

Run: `darwin-rebuild build --flake ~/dotfiles#"$(scutil --get LocalHostName)"`
Expected: 成功。

- [ ] **Step 5: 適用して挙動確認**

Run:
```bash
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
exec zsh
command -v starship && echo "starship OK"
```
Expected: 新しいプロンプトが starship 表示。補完・autosuggestion・syntax-highlighting が効く。p10k のプロンプトが出ない。

- [ ] **Step 6: 旧 zsh 資産の撤去**

`.zshrc` は home-manager が生成するため、リポジトリの `.zshrc` を撤去。`.bin/init.sh` の oh-my-zsh 導入ブロックも削除。

Run:
```bash
cd ~/dotfiles
git rm .zshrc
```
`.bin/init.sh` を編集し oh-my-zsh 導入ブロックを削除（tpm ブロックは当面維持）。`~/.oh-my-zsh` は任意で手動削除。

- [ ] **Step 7: Commit**

```bash
git add home/zsh.nix home/default.nix .bin/init.sh
git rm --cached .zshrc 2>/dev/null || true
git commit -m "feat: zshをhome-manager化しstarship導入・oh-my-zsh/p10k廃止（Phase3）"
```

---

## Phase 4: dotfiles

### Task 6: 設定ファイルを home-manager（mkOutOfStoreSymlink）で管理し link.sh を撤去

**Files:**
- Create: `home/dotfiles.nix`
- Modify: `home/default.nix`（import 追加）
- Delete: `.bin/link.sh`
- Modify: `Makefile`（`link` ターゲット除去）

**Interfaces:**
- Consumes: リポジトリ内の設定実体（`~/dotfiles/.config/*`, `.tmux.conf` 等）
- Produces: `~/.config/*` 等への out-of-store シンボリックリンク

- [ ] **Step 1: `home/dotfiles.nix` を作成**

`mkOutOfStoreSymlink` でリポジトリ実体への live リンクを張り、直接編集→即反映を維持。herdr は `config.toml` のみ（現行方針踏襲）。

```nix
{ config, ... }:
let
  dots = "${config.home.homeDirectory}/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in {
  home.file = {
    ".tmux.conf".source = link "${dots}/.tmux.conf";
  };

  xdg.configFile = {
    "nvim".source = link "${dots}/.config/nvim";
    "ghostty".source = link "${dots}/.config/ghostty";
    "herdr/config.toml".source = link "${dots}/.config/herdr/config.toml";
    # 既存 .config 配下の他ディレクトリも同様に追加
  };
}
```
補足: 現 `link.sh` が配布している対象を漏れなく列挙すること（`.config/*` 各ディレクトリ、ルートの dotfile 群）。starship.toml を使う場合はここに追加。

- [ ] **Step 2: 既存 symlink との衝突を解消**

home-manager は既存ファイル/リンクがあると失敗する。旧 `link.sh` が張ったリンクを退避。

Run:
```bash
for p in ~/.config/nvim ~/.config/ghostty ~/.config/herdr/config.toml ~/.tmux.conf; do
  if [ -L "$p" ]; then echo "既存リンク: $p"; rm "$p"; fi
done
```
Expected: 旧リンクを削除（実体はリポジトリにあるので安全）。

- [ ] **Step 3: import 追加とビルド検証（テスト）**

`home/default.nix`: `imports = [ ./packages.nix ./zsh.nix ./dotfiles.nix ];`

Run: `darwin-rebuild build --flake ~/dotfiles#"$(scutil --get LocalHostName)"`
Expected: 成功。

- [ ] **Step 4: 適用してリンク確認**

Run:
```bash
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
ls -l ~/.config/nvim ~/.config/herdr/config.toml ~/.tmux.conf
```
Expected: いずれも `~/dotfiles/...` を指す symlink。nvim/herdr/tmux が従来通り起動。

- [ ] **Step 5: link.sh 撤去と Makefile 修正**

Run:
```bash
cd ~/dotfiles
git rm .bin/link.sh
```
`Makefile`: `all:` から `link` を除去、`link:` ブロック削除。

- [ ] **Step 6: Commit**

```bash
git add home/dotfiles.nix home/default.nix Makefile
git commit -m "feat: dotfilesをhome-manager(mkOutOfStoreSymlink)で管理しlink.sh撤去（Phase4）"
```

---

## Phase 5: macOS 設定

### Task 7: defaults.sh を system.defaults へ移植

**Files:**
- Modify: `darwin/default.nix`（`system.defaults` 追加）
- Delete: `.bin/defaults.sh`
- Modify: `Makefile`（`defaults` ターゲット除去）

- [ ] **Step 1: 現 `defaults.sh` の設定を確認**

Run: `cat ~/dotfiles/.bin/defaults.sh`
Expected: `defaults write` 群を把握（Dock / Finder / キーボード等）。

- [ ] **Step 2: `system.defaults` に移植**

`defaults.sh` の各 `defaults write` を対応する nix-darwin オプションへ写す。例（実際の内容に合わせて調整）:

```nix
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
    };
    NSGlobalDomain = {
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;
    };
  };
```
補足: nix-darwin に対応オプションが無い `defaults write` は `system.activationScripts` で生 `defaults write` を実行して補完する。

- [ ] **Step 3: ビルド検証（テスト）**

Run: `darwin-rebuild build --flake ~/dotfiles#"$(scutil --get LocalHostName)"`
Expected: 成功。未知オプションはマニュアルで名称修正。

- [ ] **Step 4: 適用して確認**

Run:
```bash
darwin-rebuild switch --flake ~/dotfiles#"$(scutil --get LocalHostName)"
defaults read com.apple.dock autohide
```
Expected: 期待値（例 `1`）。Dock/Finder に反映（要 `killall Dock Finder` または再ログイン）。

- [ ] **Step 5: defaults.sh 撤去と Makefile 修正**

Run:
```bash
cd ~/dotfiles
git rm .bin/defaults.sh
```
`Makefile`: `all:` から `defaults` を除去、`defaults:` ブロック削除。

- [ ] **Step 6: Commit**

```bash
git add darwin/default.nix Makefile
git commit -m "feat: macOS設定をsystem.defaultsへ移植しdefaults.sh撤去（Phase5）"
```

---

## Phase 6: 後片付け

### Task 8: 旧 Make/.bin 一式を撤去し README を更新

**Files:**
- Delete: `Makefile`
- Delete: `.bin/init.sh`（tpm 導入部分は bootstrap.sh へ移すか判断）
- Modify: `README.md`
- Keep: `bootstrap.sh`, `flake.nix`, `flake.lock`, `darwin/`, `home/`

- [ ] **Step 1: 残存する `.bin` の役割を確認**

Run: `ls -la ~/dotfiles/.bin`
Expected: `init.sh`（xcode/homebrew/tpm）と `vscode.sh` が残存。xcode/homebrew は `bootstrap.sh` に集約済みのため `init.sh` は不要。tpm 導入だけ `bootstrap.sh` 末尾へ移植。`vscode.sh` はスコープ外なので残す判断も可。

- [ ] **Step 2: tpm 導入を bootstrap.sh へ移植**

`bootstrap.sh` の末尾（Homebrew 導入の後）に追記:
```bash
# tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
```

- [ ] **Step 3: 旧ファイル撤去**

Run:
```bash
cd ~/dotfiles
git rm Makefile .bin/init.sh
# vscode.sh はスコープ外。残すなら触らない
```

- [ ] **Step 4: README を更新**

`README.md` の Build 手順を Nix ベースへ書き換える:
```markdown
## Setup
```sh
git clone https://github.com/t4ichi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh                                   # Nix / CLT / Homebrew の最小導入
sudo nix run nix-darwin -- switch --flake ~/dotfiles#$(scutil --get LocalHostName)
```
以後の適用:
```sh
darwin-rebuild switch --flake ~/dotfiles#$(scutil --get LocalHostName)
```
```

- [ ] **Step 5: 最終検証（テスト）**

Run:
```bash
cd ~/dotfiles
ls Makefile .Brewfile .bin/link.sh 2>/dev/null && echo "残存あり(NG)" || echo "撤去OK"
darwin-rebuild switch --flake .#"$(scutil --get LocalHostName)"
```
Expected: `撤去OK` かつ switch 成功。宣言的構成に一本化完了。

- [ ] **Step 6: Commit**

```bash
git add -A
git commit -m "chore: 旧Make/.bin一式を撤去しREADMEをNix手順へ更新（Phase6完了）"
```

---

## Self-Review（spec 対応確認）

- spec §2 アーキテクチャ → Task 1（flake/darwin/home の土台）で実装。✓
- spec §3 パッケージ振り分け → Task 2（CLI→Nix）/ Task 3（cask・tap・service→homebrew）/ Task 4（旧経路撤去）。✓
- spec §4 シェル → Task 5（zsh+starship, oh-my-zsh/p10k 廃止, .zshrc 移植）。✓
- spec §5 dotfiles → Task 6（mkOutOfStoreSymlink, link.sh 撤去）。✓
- spec §6 macOS 設定 → Task 7（system.defaults）。✓
- spec §7 bootstrap → Task 1（bootstrap.sh）+ Task 8（tpm 移植）。✓
- spec §8 段階的移行 → Phase 1–6 に対応。各フェーズでビルド/switch 検証・コミット。✓
- spec §9 スコープ外（nvm/pyenv/tpm/vscode/Linux）→ Task 2/3/8 で「維持」を明記。✓
- spec §10 成功基準 → Task 8 Step 5 の最終検証で担保。✓
