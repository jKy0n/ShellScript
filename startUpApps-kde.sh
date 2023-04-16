#!/usr/bin/env bash
#
#
#
#
sudo cpupower frequency-set -g performance &&
sleep 3s ;
nice -n 18 plasma-systemmonitor &
nice -n 16 systemsettings5 &
#nice -n 10 /opt/sublime_text/sublime_text &
nice -n 10 atom &
nice -n 18 kdeconnect-app &
sleep 5s ;
nice -n 10 knotes &
#franz &
nice -n 14 thunderbird &
nice -n 12 ~/.joplin/Joplin.AppImage &
discord &
spotify &
sleep 8s ;
firefox &
google-chrome-stable &
sleep 2m ;
sudo cpupower frequency-set -g ondemand ;
