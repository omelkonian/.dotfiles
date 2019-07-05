#!/bin/bash
# pass "Mem"  for main memory
# and  "Swap" for swap memory
free -m | grep "$1" | awk '{print (1 - ($4 + $6) / $2) * 100}'
