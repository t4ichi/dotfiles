# Path
export PATH="$HOME/.local/bin:$PATH"

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-My-Zsh 
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k 
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# key bindings
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
