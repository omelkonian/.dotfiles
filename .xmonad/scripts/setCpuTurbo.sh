#!/bin/bash

# source ~/git/.dotfiles/bash/1-functions.symlink
# setCpuTurbo ...

case "$1" in
  disable|off|0) echo "1" > /sys/devices/system/cpu/intel_pstate/no_turbo ;;
  enable|on|1)   echo "0" > /sys/devices/system/cpu/intel_pstate/no_turbo ;;
esac
