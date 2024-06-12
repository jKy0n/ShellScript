#!/usr/bin/env bash
#
#
#
(killall picom &&    \
sleep 3 &&          \
picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx) | \
ts +'[%d-%m-%Y %H:%Mh]' >> /home/jkyon/.logs/crontab-jkyon.log
#
#
#
#
#
#
notify-send -u critical "Picom" "Now restarted\! =)"