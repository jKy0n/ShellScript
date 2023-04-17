#!/bin/bash

gsettings get org.mate.NotificationDaemon do-not-disturb | grep true &&
gsettings set org.mate.NotificationDaemon do-not-disturb false && notify-send -t 5000 "Do not disturb disabled" ||
gsettings set org.mate.NotificationDaemon do-not-disturb true
