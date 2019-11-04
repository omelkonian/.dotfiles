#!/bin/bash
source ~/git/.dotfiles/bash/1-functions.symlink
source ~/git/.dotfiles/bash/video.symlink
case $1 in
  "brighten")
    changeBrightness + 20 ;;
  "darken")
    changeBrightness - 20 ;;
  "setupScreens")
    setup_screens ;;
esac
