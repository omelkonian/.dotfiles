#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/video.symlink

# Rotate screen
echo -n "<action=callFun.sh /home/omelkonian/git/.dotfiles/bash/video.symlink rotateScreen>\
<icon=repeat.xbm/></action> "

# GPUs
fc1=$([[ $(echo `prime-select query`) == "$GPU1" ]] && echo 'green' || echo 'red')
fc2=$([[ $(echo `prime-select query`) == "$GPU2" ]] && echo 'green' || echo 'red')
cmd1="zenity --password | sudo -S prime-select $GPU1"
cmd2="zenity --password | sudo -S prime-select $GPU2"
echo "<action=$cmd1><fc=$fc1>intel</fc></action>/<action=$cmd2><fc=$fc2>nvidia</fc></action>"

