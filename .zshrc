export ZSH=/home/orestis/.oh-my-zsh
#ZSH_THEME="random"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING  _DOTS="true"

plugins=(git)

# User configuration
  export PATH="/home/orestis/bin:/opt/ros/indigo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/idea-IU-141.2735.5/bin/:/usr/lib/jvm/java-8-oracle:/home/orestis/EclipseCLP/eclipse_basic/bin/x86_64_linux"

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=10000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
zstyle :compinstall filename '/home/orestis/.zshrc'

autoload -Uz compinit
compinit

# Example aliases
alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"

# MINE!!!
# Զ  λ   𝆑   𝄞   𝄆   𝄢   𝆓
PROMPT='$fg_bold[green]λ $reset_color%'
EDITOR='subl'
function cd {
  builtin cd "$@" && ls
}
function untar {
  tar xvzf "$@"
}
export PATH=/home/orestis/bin:/opt/ros/indigo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/idea-IU-141.2735.5/bin/:/usr/lib/jvm/java-8-oracle:/home/ookrestis/EclipseCLP/eclipse_basic/bin/x86_64_linux
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv-2.4.9/bin/lib
alias fixKeyboard="ibus-daemon -rd"

alias restart_sound="pulseaudio -k && sudo alsa force-reload"

# ssh to okeanos
alias okeanos="ssh snf-709756.vm.okeanos.grnet.gr"

# virtualenv
. /usr/local/bin/virtualenvwrapper.sh
