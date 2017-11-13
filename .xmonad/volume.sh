#!/bin/bash

external='Saffire'
internal='Built-in'

if [ -n "$(pactl list sinks | grep $external)" ]; then
    card=$external
else
    card=$internal
fi

echo `pactl list sinks | grep $card -A10 | grep -o -E '[[:digit:]]+%' | head -1`
