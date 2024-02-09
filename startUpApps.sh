#!/usr/bin/env bash
#
#
#
# doas cpupower frequency-set -g performance &&
# sleep 3s ;
nice -n 5 vscode &
nice -n 18 kdeconnect-app &
#sleep 5s ;
#nice -n 10 ~/.joplin/Joplin.AppImage &
nice -n 16 pavucontrol &
nice -n 5 spotify &
discord &
sleep 2s ;
firefox &
#nice -n 16 thunderbird &
google-chrome-stable &
#sleep 2m ;
# doas cpupower frequency-set -g ondemand ;
