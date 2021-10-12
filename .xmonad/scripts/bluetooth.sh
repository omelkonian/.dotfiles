#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/audio.symlink

fc0=$([ bluetooth__enabled ] && echo 'green' || echo 'red')
echo "<fc=$fc0><icon=bluetooth.xbm/></fc>"
