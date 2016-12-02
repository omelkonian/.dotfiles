export ZSH=~/.oh-my-zsh
# ZSH_THEME="random"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"

plugins=(git colored-man-pages colorize extract history cabal pip
         zsh-syntax-highlighting
        )

# User configuration
  export PATH="~/bin:/opt/ros/indigo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/idea-IU-141.2735.5/bin/"

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
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

# Syntax highlighting options
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green, bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=yellow, bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green, bold'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue, bold'

EDITOR='subl'

# Remap CapsLock as Ctrl/Escape
setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape'
alias caps_off="xdotool key Caps_Lock"

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
alias lt="ll -tr"

# General
add_to_path /usr/local/sbin
add_to_path /usr/local/bin
add_to_path /usr/sbin
add_to_path /usr/bin
add_to_path /sbin
add_to_path /bin
add_to_path ~/bin

# SED
function delete_between {
  sed -n '1,/"$1"/p;/"$2"/,$p' $3 > tmp && mv tmp $3
}

# C++
alias g++="g++ --std=c++11"
alias gpp="gpp --std=c++11"

# Noglobs
alias git="noglob git"
alias pip="noglob pip"

# Python
alias pipall="pip list | awk '{print $1}' | xargs pip uninstall -y"

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
work() {
    workon "$1"
    cdvirtualenv src/"$1"
}

# sqlite
export SQLALCHEMY_DATABASE_URI="sqlite:///foo.db"

# kwalitee binary file
add_to_path ~/.local/bni

# Play framework
add_to_path /opt/Activator/bin/

# EclipseCLP
add_to_path ~/EclipseCLP/eclipse_basic/bin/x86_64_linux

# Intellij
add_to_path /home/orestis/Intellij/bin

# DroidCam
alias droid_connect="sudo droidcam-cli 192.168.0.27 4747"

# cabal
add_to_path ~/.cabal/bin

# idris
add_to_path ~/Idris/.cabal-sandbox/bin

# IP
get_ip() {
  ip route get 8.8.8.8 | awk '{print $NF; exit}'
}

# Haskell
add_to_path ~/.local/bin

# stack autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

# CDS
cds_setup() {
  export FLASK_DEBUG=1
  export SQLALCHEMY_DATABASE_URI="mysql+pymysql://root:123456@localhost:3306/invenio"
}
cds_cd() {
  cdvirtualenv src/cds
}
cds_install() {
  $(cds_cd)
  python -O -m compileall .
  cds npm
  cdvirtualenv var/instance/static
  npm install
  cds collect -v
  cds assets build
  $(cds_cd)
}
cds_init() {
  cds db init
  cds db create
  cds users create test@test.ch -a
  cds index init
}
cds_fixtures() {
  cds fixtures cds
  cds fixtures files
}
cds_all() {
  $(cds_install)
  $(cds_init)
  $(cds_fixtures)
}
cds_del() {
  yes | cds db destroy
  yes | cds index destroy
}
cds_reset() {
  $(cds_del)
  cds db init
  cds db create
  cds index init
  cds fixtures cds
  cds fixtures files
}
alias cds_run="cds run --debugger"
alias cds_celery="celery -A cds.celery worker -l info"

# Audio
alias unmute="pacmd set-sink-mute 0 0"
