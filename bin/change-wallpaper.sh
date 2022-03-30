#!/usr/bin/env bash

rand_wall=$(find ~/.config/wallpapers -xtype f | sort -R | head -n +1)
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $rand_wall

