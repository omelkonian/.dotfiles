#!/bin/bash
s=$(echo $1 | tr "[:upper:]" "[:lower:]")

function callEmacs {
  local id=$1
  local cmd=$2
  local suffix=$3
  local sleepDur=${4:-0}
  local wid=$id$suffix
  if [ -z "$(wmctrl -l | cut -d' ' -f5 | grep "^$id\(-at.\)\?$")" ] ; then
    sleep $sleepDur && emacs --name=$wid --eval "$cmd" &
  else
    notify-send "QuickStart" "$id[-at_] already open"
  fi
}

case $s in
  gen)
    fs=$(cat ~/git/.dotfiles/.xmonad/scripts/quickstart.sh | grep -e '^  [^ ]*)' | cut -d')' -f1 | cut -d' ' -f3)
    notify-send "QuickStart (gen)" "$fs"
    for f in $fs
    do
      fn=~/.local/share/applications/emacs_$f.desktop
      if [ ! -f $fn ]; then
        echo """
[Desktop Entry]
X-SnapInstanceName=emacs
Name=Emacs Quickstart ($f)
GenericName=Text Editor
Comment=Edit text
Exec=/home/omelkonian/.xmonad/scripts/quickstart.sh $f
Icon=/snap/emacs/1411/usr/share/icons/hicolor/scalable/apps/emacs.svg
Type=Application
Terminal=false
Categories=Development;TextEditor;
StartupWMClass=Emacs
Keywords=Text;Editor;""" > $fn
        chmod +x $fn
      fi
    done
    ;;
  repl)
    callEmacs $s '(quickAgda "personal-practice/agda" "REPL")' ;;
  stdlib)
    callEmacs $s '(quickAgda "agda-stdlib" "Everything")' ;;
  stdlib-fork)
    callEmacs $s '(quickAgda "agda-stdlib-fork" "Everything")' ;;
  prelude)
    callEmacs $s '(quickAgda "formal-prelude" "Prelude/Main")' ;;
  thesis)
    callEmacs $s '(quickTex "phd-thesis/thesis" "main")' '-at5' ;;
  bitcoin)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "formal-bitcoin" "Bitcoin")' '-at5' 2 ;;
  bitml)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "formal-bitml" "BitML")' '-at5' 2 ;;
  bitml-to-bitcoin)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs bitcoin '(quickAgda "formal-bitcoin" "Bitcoin")' '-at8' 2
    callEmacs bitml '(quickAgda "formal-bitml" "BitML")' '-at8' 2
    callEmacs $s '(quickAgda "formal-bitml-to-bitcoin" "SecureCompilation/Coherence")' '-at5' 2 ;;
  hoare)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "hoare-ledgers" "Main")' '-at5' 2 ;;
  nom)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "nominal-agda" "Main")' '-at5' 2 ;;
  iliagda)
    callEmacs stdlib '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs $s '(quickAgda "iliagda" "Main")' '-at5' 2 ;;
  mtg)
    callEmacs stdlib '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs $s '(quickAgda "formal-mtg" "Main")' '-at5' 2 ;;
  utxo)
    callEmacs stdlib '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs $s '(quickAgda "formal-utxo" "Main")' '-at5' 2 ;;
  agda2train)
    callEmacs $s '(quickAgda "agda2train/test" "All")' '-at5' 2 ;;
esac
