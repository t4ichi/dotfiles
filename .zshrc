# Path
export PATH="/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Powerlevel10k instant prompt
P10K_PROMPT="${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ -r "$P10K_PROMPT" ]] && source "$P10K_PROMPT"

# Oh-My-Zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# key bindings
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Neovim 
export EDITOR=nvim

# Alias
alias lg='lazygit'
alias ld='lazydocker'
alias dc='docker-compose'
alias vi='nvim'

