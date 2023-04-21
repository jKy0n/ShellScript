#!/usr/bin/env bash
sudo cpupower frequency-set -g performance &&
sleep 3s ;
nice -n 5 vscode &
#nice -n 18 kdeconnect-app &
sleep 5s ;
nice -n 16 thunderbird &
nice -n 10 ~/.joplin/Joplin.AppImage &
discord &
nice -n 5 spotify &
sleep 8s ;
firefox &
google-chrome-stable &
sleep 2m ;
sudo cpupower frequency-set -g ondemand ;