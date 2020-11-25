#!/bin/bash
source ~/git/.dotfiles/bash/1-functions.symlink
source ~/git/.dotfiles/bash/video.symlink
source ~/git/.dotfiles/bash/keyboard.symlink
op=$1
shift
case $op in
  "brighten")
    changeBrightness + 20 ;;
  "darken")
    changeBrightness - 20 ;;
  "setupScreens")
    setup_screens ;;
  "swfToAvi")
    swfToAvi "$@" ;;
esac
