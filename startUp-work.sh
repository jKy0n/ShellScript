#!/usr/bin/env bash
#
# Quick startUp programs routine #
# By jKyon =) #
#
#
#
#
#
#
sudo cpupower frequency-set -g performance &&
sleep 5 ;
#nice -n 18 gnome-system-monitor &
#nice -n 18 plasma-systemmonitor &
#nice -n 18 kdeconnect-app &
nice -n 16 xpad &
#nice -n 12 knotes &
firefox &
sleep 3 &&
#nice -n 10 /opt/sublime_text/sublime_text &
code &
#atom &
nice -n 10 /home/jkyon/.joplin/Joplin.AppImage &
nice -n 16 thunderbird &
sleep 3 &&
nice -n 4 spotify &
nice -n 4 discord &
#sh ~/ShellScript/Spotify-fix.sh ;
#franz &
#nice -n 5 rambox &
sleep 4m &&
sudo cpupower frequency-set -g ondemand ;
