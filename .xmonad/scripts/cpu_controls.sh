#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/1-functions.symlink
cmd=$1
shift
case "$cmd" in
  "enable_turbo")
    setCpuTurbo enable ;;
  "disable_turbo")
    setCpuTurbo disable ;;
  "toggle_turbo")
    if turbo__enabled; then
      setCpuTurbo disable
    else
      setCpuTurbo enable
    fi
esac
