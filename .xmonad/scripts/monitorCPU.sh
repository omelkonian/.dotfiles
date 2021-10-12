#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/1-functions.symlink

echo "<action=zenity --password | sudo -S /home/omelkonian/.xmonad/scripts/cpu_controls.sh 'toggle_turbo'>\
(<fc=$(turbo__enabled && echo 'green' || echo 'red')>T</fc>\
</action>\
$(getCpuFreqMin)) \
<action=zenity --password | sudo -S /home/omelkonian/.xmonad/scripts/prochot_fix.sh>\
<icon=temp.xbm/> $(getTempMax) \
</action>"
