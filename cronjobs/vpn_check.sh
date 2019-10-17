#!/bin/bash
pid=$(pgrep transmission)
vpnStatus=$(nordvpn status | grep "Disconnected")
if [ -n "$pid" ] && [ -n "$vpnStatus" ]; then
  kill -9 $pid
fi
