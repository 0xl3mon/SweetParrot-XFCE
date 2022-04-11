#!/usr/bin/env bash

readonly icon_dir="/home/${USER}/.local/bin/icons/skull-vpn.png"
readonly ip_vpn="$(/sbin/ifconfig | grep 'tun[0-9]' -A 1 | grep inet |  head -n 1 | awk '{print $2}')"

if [[ -z $ip_vpn ]] ; then
	info="<img>${icon_dir}</img>"
	info+="<txt> Disconnected</txt>"
else
	info="<img>${icon_dir}</img><txt>"
	info+="${ip_vpn}</txt>"
fi

echo -ne "${info}"
