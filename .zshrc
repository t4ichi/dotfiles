# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path
export PATH="/usr/local/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Zsh plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

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
