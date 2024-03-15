#!/usr/bin/zsh
source /home/omelkonian/git/.dotfiles/zsh/functions.symlink

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

# function agda-locate-latex-dir-of {
#   builtin cd $(dirname "$1")
#   agda-locate-latex-dir
#   builtin cd - > /dev/null
# }
