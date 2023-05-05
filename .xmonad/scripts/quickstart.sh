#!/bin/bash
s=$(echo $1 | tr "[:upper:]" "[:lower:]")

function callEmacs {
  if [ -z "$(wmctrl -l | cut -d' ' -f5 | grep $s)" ] ; then
    sleep ${3:-0} && emacs --name=$s$2 --eval "$1" &
  else
    notify-send "QuickStart" "$s already open"
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
    callEmacs '(quickAgda "personal-practice/agda" "REPL")' ;;
  stdlib)
    callEmacs '(quickAgda "agda-stdlib" "Everything")' ;;
  stdlib-fork)
    callEmacs '(quickAgda "agda-stdlib-fork" "Everything")' ;;
  prelude)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' ;;
  thesis)
    callEmacs '(quickTex "phd-thesis/thesis" "thesis")' '-at5' ;;
  bitcoin)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs '(quickAgda "formal-bitcoin" "Bitcoin")' '-at5' 2 ;;
  bitml)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs '(quickAgda "formal-bitml" "BitML")' '-at5' 2 ;;
  bitml-to-bitcoin)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs '(quickAgda "formal-bitcoin" "Bitcoin")' '-at8' 2
    callEmacs '(quickAgda "formal-bitml" "BitML")' '-at8' 2
    callEmacs '(quickAgda "formal-bitml-to-bitcoin" "SecureCompilation/Coherence")' '-at5' 2 ;;
  hoare)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs '(quickAgda "hoare-ledgers" "Main")' '-at5' 2 ;;
  nom)
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs '(quickAgda "nominal-agda" "Main")' '-at5' 2 ;;
  iliagda)
    callEmacs '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs '(quickAgda "iliagda" "Main")' '-at5' 2 ;;
  mtg)
    callEmacs '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs '(quickAgda "formal-mtg" "Main")' '-at5' 2 ;;
  utxo)
    callEmacs '(quickAgda "agda-stdlib" "Everything")' '-at8'
    callEmacs '(quickAgda "formal-prelude" "Prelude/Main")' '-at8' 2
    callEmacs '(quickAgda "formal-utxo" "Main")' '-at5' 2 ;;
  agda2train)
    callEmacs '(quickAgda "formal-utxo" "Main")' '-at5' 2 ;;
esac
