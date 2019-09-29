#!/bin/bash
source ~/git/.dotfiles/bash/audio.symlink
case $1 in
  "play/pause")
    audio__play_pause ;;
  "next")
    audio__next ;;
  "prev")
    audio__prev ;;
esac
