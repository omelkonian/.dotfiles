#!/bin/bash
/usr/bin/ofono-phonesim -p 12345 /usr/share/phonesim/default.xml &
/usr/share/ofono/scripts/enable-modem /phonesim
/usr/share/ofono/scripts/online-modem /phonesim
sleep infinity
