#!/bin/bash

external='Saffire'
external_id='alsa_output.usb-Focusrite_Audio_Engineering_Saffire_6USB-00.analog-surround-40'
internal='Built-in'
internal_id='alsa_output.pci-0000_00_1b.0.analog-stereo'

if [ -n "$(pactl list sinks | grep $external)" ]; then
    card=$external_id
else
    card=$internal_id
fi

pactl set-sink-volume "$card" "$1"
