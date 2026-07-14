{ ... }:
{
  # プロンプトは starship（powerlevel10k lean スタイルを再現）
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # 単一行・プロンプト間の空行なし（p10k lean 相当）
      add_newline = false;

      format = "$os$directory$git_branch$git_status$character";
      # 右側に実行時間と時刻（p10k lean の右プロンプト相当）
      right_format = "$cmd_duration$time";

      # OS アイコン（Apple）
      os = {
        disabled = false;
        format = "[$symbol]($style) ";
        style = "bold white";
        symbols.Macos = "";
      };

      # ディレクトリ（p10k: 親=31 teal / repo root=39 bold 青）
      directory = {
        style = "31";                   # 親パス: teal
        before_repo_root_style = "31";  # リポジトリより上の親: teal
        repo_root_style = "bold 39";    # リポジトリのルート: 明るい青・太字（p10k anchor 相当）
        truncate_to_repo = false;       # フルパスを表示
        truncation_length = 10;
        fish_style_pwd_dir_length = 1;  # 親を1文字省略（深い階層で効く）
        format = "[$path]($style) ";
      };

      # git ブランチ（p10k: 緑・ブランチアイコン）
      git_branch = {
        symbol = " ";
        style = "76";
        format = "[$symbol$branch]($style) ";
      };

      # git 状態（p10k: clean/untracked 76 緑基調）
      git_status = {
        style = "76";
      };

      # プロンプト記号（p10k: 成功=緑❯ / 失敗=赤❯ / vicmd=❮）
      character = {
        success_symbol = "[❯](bold 76)";
        error_symbol = "[❯](bold 196)";
        vicmd_symbol = "[❮](bold 76)";
      };

      # 実行時間（2秒以上かかったコマンドのみ表示。しきい値であり表示遅延は発生しない）
      cmd_duration = {
        min_time = 2000;
        style = "101";
        format = "[$duration]($style) ";
      };

      # 時刻（p10k: HH:MM:SS）
      time = {
        disabled = false;
        time_format = "%H:%M:%S";
        style = "66";
        format = "[$time]($style)";
      };

      # p10k ではコマンド実行時のみ表示だったクラウド系は常時表示を無効化
      gcloud.disabled = true;
      aws.disabled = true;
      kubernetes.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;

    # ディレクトリ名を打つだけで cd（`..` で上へ）。エイリアス不要の zsh 標準機能。
    autocd = true;

    # oh-my-zsh / brew 版プラグインを廃止し home-manager ネイティブへ
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # zcompdump が 24h 以内なら compaudit(全fpath検査 ~0.9s) を省略(-C)して高速起動。
    completionInit = ''
      autoload -Uz compinit
      _zcd=("$HOME/.zcompdump"(Nmh-24))   # 24h以内なら非空
      compinit ''${_zcd:+-C} -d "$HOME/.zcompdump"
    '';

    shellAliases = {
      lg = "lazygit";
      vi = "nvim";
      # md を GitHub 風にブラウザ表示（md間リンク遷移可）。例: mdp path/to/doc.md
      mdp = "go-grip";
      # check + typecheck を実行し、出力を画面表示しつつクリップボードへコピー
      pc = "(pnpm check && pnpm tsc) 2>&1 | tee >(pbcopy)";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    # 旧 .zshrc の残り（PATH / brew / mise / キーバインド等）を移植。
    # ※ p10k instant-prompt / oh-my-zsh / brew版プラグイン読込は廃止済み。
    initContent = ''
      # マシン固有のプロキシ設定は公開リポジトリに含めないため、
      # .gitignore 済みの実体を symlink 経由で参照し、実行時に読む。
      [ -f "$HOME/.config/zsh/proxy.env" ] && source "$HOME/.config/zsh/proxy.env"

      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # PATH（ローカル・cargo）
      export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

      # 履歴インクリメンタル検索
      bindkey '^P' history-beginning-search-backward
      bindkey '^N' history-beginning-search-forward

      # mise（ランタイムのバージョン管理。nvm を置き換え）
      eval "$(mise activate zsh)"

      # mysql-client
      export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

      # Vite+ bin (https://viteplus.dev)
      [ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

      # devcontainers
      export PATH="$HOME/.devcontainers/bin:$PATH"
    '';
  };
}
