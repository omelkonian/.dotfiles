#!/bin/bash
case $(nordvpn status | head -n1) in
  "Status: Connected")
    echo "<action=nordvpn d>∃</action>";;
  *)
    echo "<action=nordvpn c nl492>∄</action>";;
esac
