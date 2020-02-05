#!/bin/bash
source ~/git/.dotfiles/bash/exports.symlink
source ~/git/.dotfiles/bash/1-functions.symlink
cmd=$1
shift
case "$cmd" in
  "bw")
    print_bw $@ ;;
  "cl")
    print_cl $@ ;;
esac
