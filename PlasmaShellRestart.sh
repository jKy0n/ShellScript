##!/usr/bin/env bash
sed -i '/BorderlessMaximizedWindows*/c\BorderlessMaximizedWindows=true' ~/.config/kwinrc &&
killall kwin_x11 &&
kquitapp5 plasmashell &&
sleep 2s &&
kstart5 plasmashell &
kwin_x11 &
