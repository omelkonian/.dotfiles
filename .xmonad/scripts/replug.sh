#!/bin/bash
source /home/omelkonian/git/.dotfiles/bash/0-constants.symlink
source $MEHOME/git/.dotfiles/bash/1-functions.symlink

port="1-2.4"  # .3"
usb__unbind $port
sleep 1
usb__bind $port
