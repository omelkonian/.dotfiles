#!/bin/bash
source ~/git/.dotfiles/bash/video.symlink
case $1 in
  "brighten")
    changeBrightness + 20 ;;
  "darken")
    changeBrightness - 20 ;;
esac
