#!/usr/bin/env bash

ICON="/usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg"
LOG_FILE="/home/jkyon/.logs/Portage-dailyRoutine.log"

# Exporta o endereço do D-Bus do usuário para o comando notify-send
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Roda os scripts necessários
sh /home/jkyon/ShellScript/PortageUpdateMirrors.sh && sh /home/jkyon/ShellScript/PortageSync.sh

if [ $? -ne 0 ]; then
    echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao rodar script dailyRoutine" >> $LOG_FILE
    sudo -u jkyon DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS notify-send -u critical -i $ICON "Portage" "Error in to run update"
else
    sudo -u jkyon DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS notify-send -u normal -i $ICON "Portage" "Gentoo is updated"
fi

