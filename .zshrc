export ZSH=~/.oh-my-zsh
# ZSH_THEME="random"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(git
         colored-man-pages
         colorize extract
         history
         cabal
         pip
         zsh-syntax-highlighting)


source $ZSH/oh-my-zsh.sh

HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# Imports
for file in ~/git/.dotfiles/bash/*.symlink ; do
    . $file
done
