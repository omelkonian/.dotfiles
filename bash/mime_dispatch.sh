#!/bin/bash

f=$1
case ${f##*.} in
  "agda")
    emacs "$f" ;;
  *)
    subl "$f" ;;
esac
