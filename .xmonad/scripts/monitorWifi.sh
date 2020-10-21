#!/bin/bash
signal0=`awk 'NR==3 {print $3}''' /proc/net/wireless`
signal=${signal0:0:-1}
echo "<icon=net-wifi.xbm/> ${signal}%"
