#!/bin/bash

# source /home/omelkonian/git/.dotfiles/bash/1-functions.symlink
# prochot_fix
# setCpuTurbo enable

# set CPU profile to 'performance' 
for i in {0..7}; do
  sudo cpufreq-set -c $i -g performance
done

# handle BD PROCHOT
BD_PROCHOT="0x1FC"
sudo modprobe msr
r="0x$(sudo rdmsr $BD_PROCHOT)"
f=$(($r&0xFFFFE)) # turn off
# f=$(($r|0x00001)) # turn on
sudo wrmsr $BD_PROCHOT "obase=16;$f"|bc

# undervolt (disabled after BIOS > 1.18.0)
# sudo undervolt --core -135 --cache -135

# disable turbo
echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
# enable turbo
# echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
