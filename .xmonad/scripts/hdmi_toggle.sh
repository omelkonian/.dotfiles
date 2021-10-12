#!/bin/bash
set -euo pipefail

# flock -xnF /var/lock/hdmi_toggle.lock notify-send "UDEV" "HDMI status changed"
source /home/omelkonian/git/.dotfiles/bash/keyboard.symlink
source /home/omelkonian/git/.dotfiles/bash/video.symlink
setup_screens
source /home/omelkonian/git/.dotfiles/bash/audio.symlink
setup_audio
# sleep 10
