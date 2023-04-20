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
#nice -n 16 xpad &
firefox &
sleep 3 &&
vscode &
nice -n 12 ~/.joplin/Joplin.AppImage &
nice -n 16 thunderbird &
sleep 3 &&
nice -n 5 spotify &
nice -n 10 discord &
#nice -n 5 rambox &
sleep 4m &&
sudo cpupower frequency-set -g ondemand ;
