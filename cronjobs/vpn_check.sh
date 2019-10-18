#!/bin/bash
for i in {1..59}; do
  pid=$(pgrep transmission)
  vpnStatus=$(nordvpn status | grep "Disconnected")
  if [ -n "$pid" ] && [ -n "$vpnStatus" ]; then
    notify-send "NO VPN: Killing transmission"
    kill -9 $pid
  fi
  sleep 1;
done
