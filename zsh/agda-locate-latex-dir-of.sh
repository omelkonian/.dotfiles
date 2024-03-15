#!/usr/bin/zsh
source /home/omelkonian/git/.dotfiles/zsh/functions.symlink

cd $(dirname "$1")
latexDir=$(findParentRelative latex)
if [ ! -z $latexDir ]; then
  echo -n "$latexDir"
else;
  latexDir=$(findParentRelative agda.sty)
  if [ ! -z $latexDir ]; then
    echo -n "$latexDir"
  else
    echo -n "."
  fi
fi
cd - > /dev/null
