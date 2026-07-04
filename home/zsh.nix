{ ... }:
{
  # プロンプトは starship（powerlevel10k を置き換え）
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
