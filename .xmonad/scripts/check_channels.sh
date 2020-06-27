#!/bin/bash
source ~/git/.dotfiles/bash/audio.symlink
if [ -z "$(pgrep "speaker-test")" ] ; then
  echo "<action=speaker-test -t wav -c 2><fc=red><icon=music.xbm/></fc></action>"
else
  echo "<action=pkill 'speaker-test'><fc=green><icon=music.xbm/></fc></action>"
  
fi

