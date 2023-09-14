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

unalias gr

# auto-completion
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Theme
PROMPT='%B%F{green}λ%f%b '

#ZLE_RPROMPT_INDENT=0
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"
RPROMPT='$(git_prompt_info)'

# Syntax highlighting options
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green, bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green, bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue, bold'

# Noglobs
alias git="noglob git"
alias g="noglob git"
alias pip="noglob pip"
alias stack="noglob stack"

# Init
source ~/git/.dotfiles/.initrc
