!/usr/bin/env bash
#
#
#
# sudo cpupower frequency-set -g performance &&
# sleep 3s ;
nice -n 5 vscode &
kdeconnectd &
nice -n 18 kdeconnect-app &
# sleep 5s ;
# nice -n 10 ~/.joplin/Joplin.AppImage &
nice -n 10 obsidian &
backintime &
nice -n 16 pavucontrol &
nice -n 5 spotify &
# pulseeffects &
discord &
# sleep 2s ;
firefox &
nice -n 16 thunderbird &
google-chrome-stable &
# sleep 2m ;
# sudo cpupower frequency-set -g ondemand ;