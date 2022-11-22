#!/bin/bash
case $1 in 
  repl|REPL)
    emacs --eval '(quickstart "personal-practice/agda" "REPL")' & ;;
  stdlib|Standard)
    emacs --eval '(quickstart "agda-stdlib" "Everything")' & ;;
  stdlib-fork|StandardFork)
    emacs --eval '(quickstart "agda-stdlib-fork" "Everything")' & ;;
  prelude|Prelude)
    emacs --eval '(quickstart "formal-prelude" "Prelude/Main")' & ;;
  bitcoin|Bitcoin)
    # T0D0: prevent duplicates (e.g. by checking `xmininfo -tree -root`
    emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "formal-bitcoin" "Bitcoin")' & ;;
  bitml|BitML)
    emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "formal-bitml" "BitML")' & ;;
  bitml-to-bitcoin|BitML-to-Bitcoin)
    emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at8 --eval '(quickstart "formal-bitcoin" "Bitcoin")' & 
    sleep 2 && \ 
      emacs --name=at8 --eval '(quickstart "formal-bitml" "BitML")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "formal-bitml-to-bitcoin" "SecureCompilation/Coherence")' & ;;
  sep|hoare|Hoare)
    emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "hoare-ledgers" "Main")' & ;;
  nom|nominal|Nominal)
    emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "nominal-agda" "Main")' & ;;
  iliagda|Iliagda)
    emacs --name=at8 --eval '(quickstart "agda-stdlib" "Everything")' &
    sleep 2 && \ 
      emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "iliagda" "Main")' & ;;
  mtg|MTG)
    emacs --name=at8 --eval '(quickstart "agda-stdlib" "Everything")' &
    sleep 2 && \ 
      emacs --name=at8 --eval '(quickstart "formal-prelude" "Prelude/Main")' &
    sleep 2 && \ 
      emacs --name=at5 --eval '(quickstart "formal-mtg" "Main")' & ;;
esac
