#!/bin/bash

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

sleep 2

timeout 5 notify-send \
    -u normal \
    -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg \
    "Portage" \
    "Iniciando sincronização" || true
