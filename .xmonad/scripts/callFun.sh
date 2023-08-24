#!/bin/bash

###########################################################
# Utility for calling functions inside scripts.
# Relies on git/cmd-center to generate a script's controls.
###########################################################

source /home/omelkonian/git/.dotfiles/.initrc
source /home/omelkonian/git/.dotfiles/bash/1-functions.symlink
callFun $@
