#!/bin/bash
case $(nordvpn status | head -n1) in
  "Status: Connected")
    echo "<action=nordvpn d><fc=green>∃</fc></action>";;
  *)
    echo "<action=nordvpn c nl492><fc=red>∄</fc></action>";;
esac
