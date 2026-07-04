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
        symbol = " ";
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

      # 実行時間（p10k: 3秒以上で表示）
      cmd_duration = {
        min_time = 3000;
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

    # oh-my-zsh / brew 版プラグインを廃止し home-manager ネイティブへ
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    # 旧 .zshrc の alias を移植
    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
      dc = "docker-compose";
      vi = "nvim";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    # 旧 .zshrc の残り（PATH / brew / nvm / キーバインド等）を移植。
    # ※ p10k instant-prompt / oh-my-zsh / brew版プラグイン読込は廃止済み。
    initContent = ''
      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # PATH（ローカル・cargo）
      export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

      # 履歴インクリメンタル検索
      bindkey '^P' history-beginning-search-backward
      bindkey '^N' history-beginning-search-forward

      # NVM（Homebrew で維持）
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

      # mysql-client
      export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

      # Vite+ bin (https://viteplus.dev)
      [ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

      # devcontainers
      export PATH="$HOME/.devcontainers/bin:$PATH"
    '';
  };
}
