#!/bin/bash

f=$1
case ${f##*.} in
  "agda")
    emacs24 "$f" ;;
  *)
    subl "$f" ;;
esac
