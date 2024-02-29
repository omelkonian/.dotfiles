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
    rm ~/.local/share/applications/emacs_*
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
  # Agda
  repl)
    callEmacs $s '(quickAgda "personal-practice/agda" "REPL")' ;;
  stdlib)
    callEmacs $s '(quickAgda "agda-stdlib" "Everything")' ;;
  stdlib-fork)
    callEmacs $s '(quickAgda "agda-stdlib-fork" "Everything")' ;;
  stdlib-classes)
    callEmacs $s '(quickAgda "agda-stdlib-classes" "Classes")' ;;
  stdlib-meta)
    callEmacs $s '(quickAgda "agda-stdlib-meta" "Main")' ;;
  lenses)
    callEmacs $s '(quickAgda "agda-lenses" "Lenses")' ;;
  prelude)
    callEmacs $s '(quickAgda "formal-prelude" "Prelude/Main")' ;;
  bitcoin)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "formal-bitcoin" "Bitcoin/Main")' '-at5' 2 ;;
  bitml)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs $s '(quickAgda "formal-bitml" "BitML")' '-at5' 2 ;;
  bitml-to-bitcoin)
    callEmacs prelude '(quickAgda "formal-prelude" "Prelude/Main")' '-at8'
    callEmacs bitcoin '(quickAgda "formal-bitcoin" "Bitcoin")' '-at8' 2
    callEmacs bitml '(quickAgda "formal-bitml" "BitML")' '-at8' 2
    callEmacs $s '(quickAgda "formal-bitml-to-bitcoin" "Main")' '-at5' 2 ;;
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
  verse)
    callEmacs $s '(quickAgda "formal-verse-calculus" "Verse")' ;;
  # Agda backends
  agda2hs)
    callEmacs $s '(quickAgda "agda2hs/test" "AllTests")' ;;
  agda2rust)
    callEmacs $s '(quickAgda "agda2rust/test" "AllTests")' ;;
  # TeX
  thesis)
    callEmacs $s '(quickTex "phd-thesis/thesis" "main")' ;;
  # IOHK
  ledger)
    callEmacs $s '(quickAgda "formal-ledger-specifications/src" "Everything")' ;;
  ledger-paper)
    callEmacs $s '(quickLagda "formal-ledger-paper/src" "Ledger/PDF")' ;;
  structured-contracts)
    callEmacs $s '(quickAgda "structured-contracts" "Main")' ;;
  midnight)
    callEmacs $s '(quickAgda "formal-midnight" "Everything")' ;;
  fastbft)
    callEmacs $s '(quickLagdaMd "innovation-fastbft/agda-src" "Main")' ;;
  # NeurAgda
  agda2train)
    callEmacs $s '(quickAgda "agda2train/test" "All")' ;;
  neuragda-paper)
    callEmacs $s '(quickTex "agda2train-paper" "main")' ;;
  # Featherweight Haskell
  agda2hs-scope)
    callEmacs $s '(quickAgda "agda2hs-scope/src" "Scope")' ;;
  agda-core)
    callEmacs $s '(quickAgda "agda-core/src" "Agda/Core/Typechecker")' ;;
  featherweight-haskell)
    callEmacs $s '(quickAgda "featherweight-haskell" "Main")' ;;
esac
