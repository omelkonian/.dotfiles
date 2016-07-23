export ZSH=~/.oh-my-zsh
# ZSH_THEME="random"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING  _DOTS="true"

plugins=(git)

# User configuration
  export PATH="~/bin:/opt/ros/indigo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/idea-IU-141.2735.5/bin/:/usr/lib/jvm/java-8-oracle:~/EclipseCLP/eclipse_basic/bin/x86_64_linux"

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=10000
setopt appendhistory autocd beep extendedglob nomatch notify
bindkey -e
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# Example aliases
alias zshconfig="subl ~/.zshrc"
alias ohmyzsh="subl ~/.oh-my-zsh"

# ================================= MINE ================================================

# Theme
PROMPT='%{$fg_bold[green]%}λ %{$reset_color%}' # Զ  λ   𝆑   𝄞   𝄆   𝄢   𝆓

ZLE_RPROMPT_INDENT=0
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[gray]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[gray]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✱"
RPROMPT='$(git_prompt_info)'

EDITOR='subl'

# Aliases
function cd {
  builtin cd "$@" && ls
}
function untar {
  tar xvzf "$@"
}
function mkcdir {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}
function add_to_path {
    export PATH=$PATH:"$1"
}

# General
add_to_path /usr/local/sbin
add_to_path /usr/local/bin
add_to_path /usr/sbin
add_to_path /usr/bin
add_to_path /sbin
add_to_path /bin
add_to_path ~/bin

# ROS
# source /opt/ros/indigo/setup.bash
export ROS_MAVEN_DEPLOYMENT_REPOSITORY=/home/orestis/rosjava/devel/share/maven
export ROS_MAVEN_PATH=/home/orestis/rosjava/devel/share/maven
add_to_path /opt/ros/indigo/bin

# Java
add_to_path /usr/lib/jvm/java-8-oracle
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

# OpenCV
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv-2.4.9/bin/lib

# Adhoc Fixes
alias fixKeyboard="ibus-daemon -rd"
alias fixSound="pactl exit"
alias restart_sound="pulseaudio -k && sudo alsa force-reload"

# ssh to okeanos
alias okeanos="ssh snf-709756.vm.okeanos.grnet.gr"

# virtualenv
. /usr/local/bin/virtualenvwrapper.sh

# sqlite
export SQLALCHEMY_DATABASE_URI="sqlite:///foo.db"

# kwalitee binary file
add_to_path ~/.local/bni

# Play framework
add_to_path ~/Activator/bin/

# EclipseCLP
add_to_path ~/EclipseCLP/eclipse_basic/bin/x86_64_linux
