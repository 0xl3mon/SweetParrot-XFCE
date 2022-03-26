#!/usr/bin/env bash

#icon
icon="/home/l3mon/.local/bin/icons/cave.png"

# Ip
local_ip=$(/sbin/ifconfig | grep "ens[0-9][0-9]" -A 1 | grep inet | awk '{print $2}' | tr -d '\n')

info="<img>${icon}</img>"
info+="<txt>${local_ip}</txt>"

echo -ne "${info}"
