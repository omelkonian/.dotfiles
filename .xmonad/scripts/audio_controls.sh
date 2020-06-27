#!/bin/bash
source ~/git/.dotfiles/bash/audio.symlink
cmd=$1
shift
case "$cmd" in
  "play/pause")
    audio__play_pause ;;
  "next")
    audio__next ;;
  "prev")
    audio__prev ;;
  "get_volume")
    getSinkVolume ;;
  "set_volume")
    setSinkVolume $@ ;;
  "extract_channels")
    extract_channels "$@" ;;
  "adjust_tempo")
    adjust_tempo "$@" ;;
esac
