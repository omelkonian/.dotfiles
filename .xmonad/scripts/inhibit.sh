#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/video.symlink
color=$([ -z "$(pgrep xautolock)" ] && echo 'green' || echo 'red')
action='callFun.sh ~/git/.dotfiles/bash/video.symlink inhibitor__toggle'
echo -n "<action=${action}><fc=${color}><icon=alert.xbm/></fc></action>"

source /home/omelkonian/git/.dotfiles/bash/keyboard.symlink
color=$([ -z "$(pgrep 'remote-touchpad')" ] && echo 'red' || echo 'green')
action='callFun.sh ~/git/.dotfiles/bash/keyboard.symlink remote-touchpad__toggle'
echo "<action=${action}><fc=${color}><icon=stop.xbm/></fc></action>"
