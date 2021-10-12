#!/bin/bash

f=$1
case ${f##*.} in
  "agda")
    emacs "$f" ;;
  "swf")
    ~/Downloads/flash_player/flashplayer "$f" ;;
  *)
    subl "$f" ;;
esac
