#!/bin/bash

nord__connect='nordvpn c P2P'
nord__disconnect='nordvpn d'
proton__connect='protonvpn-cli c -p udp --fastest'
proton__disconnect='protonvpn-cli d'

if [ -n "$(nordvpn status | grep 'Status: Connected')" ]; then
    echo "<action=$nord__disconnect><fc=green>∃</fc></action>"
elif [ -n "$(protonvpn-cli s | grep 'Connection time:')" ]; then
    echo "<action=$proton__disconnect><fc=green>∃</fc></action>"
else
    echo "<action=$proton__connect><fc=red>∄</fc></action>"
fi
