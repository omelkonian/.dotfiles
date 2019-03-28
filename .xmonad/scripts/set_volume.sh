#!/bin/bash

external='Saffire'
internal='Built-in'
external_id='alsa_output.usb-Focusrite'
if [ "$(hostname)" == "omelkonian-XPS-15-9560" ]; then # Dell
    internal_id='alsa_output.pci-0000_00_1f.3.analog-stereo'
else # HP
    internal_id='alsa_output.pci-0000_00_1b.0.analog-stereo'
fi
if [ -n "$(pactl list sinks | grep $external)" ]; then
    card=$(pactl list sinks | grep "Name: $external_id" -B 2 | grep 'Sink #' | grep -o -E '[[:digit:]]+')
else
    card=$internal_id
fi

pactl set-sink-volume "$card" "$1"
