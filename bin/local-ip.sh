#!/usr/bin/env bash

# Colors
bold="\e[1m"
reset="\e[0m"

# Ip
ip=$(/sbin/ifconfig ens33 | grep -w inet | awk '{print $2}')

echo -ne "$ip"
