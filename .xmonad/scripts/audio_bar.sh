#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/audio.symlink

if [ -z "$(pgrep "speaker-test")" ] ; then
  fc0='red'
  cmd='speaker-test -t wav -c 2'
else
  fc0='green'
  cmd="pkill 'speaker-test'"
fi
echo -n "<action=$cmd><fc=$fc0><icon=music.xbm/></fc></action> "

# HDMI 
echo -n "<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink toggle_HDMI>\
<fc=$(connected_HDMI_sound && selected_HDMI_sound && echo 'green' || echo 'red')>HDMI</fc></action>"

# JBL via bluetooth
echo -n "/<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink bluetooth__toggle $JBL_CHARGE_4>\
<fc=$(bluetooth__connected $JBL_CHARGE_4 && echo 'green' || echo 'red')>JBL</fc></action>"

# Soundbox via bluetooth
echo -n "/<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink bluetooth__toggle $SKY_SOUNDBOX>\
<fc=$(bluetooth__connected $SKY_SOUNDBOX && echo 'green' || echo 'red')>Sky</fc></action>"

# MiEarphones via bluetooth
echo -n "/<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink bluetooth__toggle $MI_EARPHONES>\
<fc=$(bluetooth__connected $MI_EARPHONES && echo 'green' || echo 'red')>Mi</fc></action>"

# LpEarphones via bluetooth
echo -n "/<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink bluetooth__toggle $LP_EARPHONES>\
<fc=$(bluetooth__connected $LP_EARPHONES && echo 'green' || echo 'red')>LP</fc></action>"

# Marshall MAJOR-IV earphones via bluetooth
echo -n "/<action=callFun.sh ~/git/.dotfiles/bash/audio.symlink bluetooth__toggle $MARSHALL_MAJOR_IV>\
<fc=$(bluetooth__connected $MARSHALL_MAJOR_IV && echo 'green' || echo 'red')>MJ</fc></action>"

fc0=$([ bluetooth__enabled ] && echo 'green' || echo 'red')
echo -n " <fc=$fc0><icon=bluetooth.xbm/></fc>"

# Volume control
echo " <icon=vol-hi.xbm/>"

