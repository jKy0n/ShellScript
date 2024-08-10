#!/usr/bin/env bash
#
#
#
# NOTE: Version 1.1:
#
#
#
#
ICON="/usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg"
LOG_FILE="/home/jkyon/.logs/Portage-dailyRoutine.log"
#
#
#
sh /home/jkyon/ShellScript/PortageUpdateMirrors.sh && sh /home/jkyon/ShellScript/PortageSync.sh
#
if [ $? -ne 0 ]; then
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao rodar script dailyRoutine" >> $LOG_FILE
        sudo -u jkyon notify-send -u critical -i $ICON "Portage" "Error in to run update"
    else
        sudo -u jkyon notify-send -u normal -i $ICON "Portage" "Gentoo is updated"
    fi
