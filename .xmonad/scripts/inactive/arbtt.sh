#!/bin/bash
if [ -z "$(pgrep arbtt-capture)" ] ; then
  echo '<action=in=$(zenity --entry --text "Basename of logfile:") && arbtt-capture -f ~/Dropbox/Migamake/reviews/$in.log><fc=red>∄</fc></action>'
else
  echo '<action=pkill arbtt-capture><fc=green>∃</fc></action>'
fi
