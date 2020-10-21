#!/bin/bash
signal0=`awk 'NR==3 {print $3}''' /proc/net/wireless`
signal=`echo "10/7 * ${signal0:0:-1}" | bc -l`
printf "<icon=net-wifi.xbm/> %0.1f%%\n" $signal
