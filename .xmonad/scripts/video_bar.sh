#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/video.symlink
source /home/omelkonian/git/.dotfiles/bash/keyboard.symlink
source /home/omelkonian/git/.dotfiles/bash/settings.symlink

# DnD
color=$($(dnd__enabled) && echo 'green' || echo 'red')
action='callFun.sh /home/omelkonian/git/.dotfiles/bash/settings.symlink dnd__toggle'
echo -n "<action=${action}><fc=${color}><icon=alert.xbm/></fc></action>"

# Remote touchpad
color=$($(remote-touchpad__enabled) && echo 'green' || echo 'red')
action='callFun.sh /home/omelkonian/git/.dotfiles/bash/keyboard.symlink remote-touchpad__toggle'
echo -n "<action=${action}><fc=${color}><icon=stop.xbm/></fc></action>"

# Rotate screen
cmd="zenity --question --text 'Are you sure you want to rotate the screen?'"
echo -n "<action=$cmd && callFun.sh /home/omelkonian/git/.dotfiles/bash/video.symlink rotateScreen>\
<icon=repeat.xbm/></action> "

# GPUs
fc1=$([[ $(echo `prime-select query`) == "$GPU1" ]] && echo 'green' || echo 'red')
fc2=$([[ $(echo `prime-select query`) == "$GPU2" ]] && echo 'green' || echo 'red')
cmd1="zenity --password | sudo -S prime-select $GPU1"
cmd2="zenity --password | sudo -S prime-select $GPU2"
echo "<action=$cmd1><fc=$fc1>intel</fc></action>/<action=$cmd2><fc=$fc2>nvidia</fc></action>"
