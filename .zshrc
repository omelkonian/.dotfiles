export ZSH=/home/omelkonian/.oh-my-zsh
# ZSH_THEME="random"

CASE_SENSITIVE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(git
         colored-man-pages
         colorize extract
         history
         cabal
         pip
         zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

HISTFILE=/home/omelkonian/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
zstyle :compinstall filename '/home/omelkonian/.zshrc'

autoload -Uz compinit
compinit

unalias gr

# Imports
for file in /home/omelkonian/git/.dotfiles/bash/*.symlink; do
    if [[ $file != *"controls"* ]]; then
      . $file
    fi
done

# Stack auto-completion
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
