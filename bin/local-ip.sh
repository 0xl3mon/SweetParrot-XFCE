#!/usr/bin/env bash

#icon
icon="/home/${USER}/.local/bin/icons/castle-localhost.png"

# Ip
local_ip=$(/sbin/ifconfig | grep -E "ens[0-9][0-9]?|eth?[0-9]0-9]?" -A 1 | grep inet | awk '{print $2}' | tr -d '\n')

info="<img>${icon}</img>"
info+="<txt>${local_ip}</txt>"

echo -ne "${info}"
