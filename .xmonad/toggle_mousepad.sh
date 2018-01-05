#!/bin/bash
mousepad=12
if [  $(xinput list-props 12 | grep "Enabled" | cut -d ':' -f 2 | grep -oe '\([0-9.]*\)') = 1 ]; then
    xinput --disable $mousepad
else
    xinput --enable $mousepad
fi
