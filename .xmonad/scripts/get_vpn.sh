#!/bin/bash
if [ -n "$(nordvpn status | grep 'Status: Connected')" ] ; then
    echo "<action=nordvpn d><fc=green>∃</fc></action>"
else
    echo "<action=nordvpn c P2P><fc=red>∄</fc></action>"
fi
