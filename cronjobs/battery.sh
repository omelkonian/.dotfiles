#!/bin/bash
export DISPLAY=:0.0
threshold=10
level=$(acpi | grep -Po "(?<=, ).*(?=%)")
info=$(acpi | cut -d ',' -f2-)
if (( $level < $threshold )) ; then
  notify-send "BATTERY LOW" "${info}"
fi
