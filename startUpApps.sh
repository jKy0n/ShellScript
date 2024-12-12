#!/usr/bin/env bash
#
#
#
# sudo cpupower frequency-set -g performance &&
# sleep 3s ;
vscode &
kdeconnectd &
nice -n 18 kdeconnect-app &
# sleep 5s ;
nice -n 5 obsidian &
# backintime &
nice -n 15 pavucontrol &
nice -n 5 spotify &
# pulseeffects &
discord &
# sleep 2s ;
nice -n 16 thunderbird &
firefox &
google-chrome-stable &
# sleep 2m ;
# sudo cpupower frequency-set -g ondemand ;