#!/usr/bin/env bash
#
#
#
# NOTE: Version 1:
#
#
ICON="/usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg"
LOG_FILE="/home/jkyon/.logs/PortageUpdateMirrors-dailyRoutine.log"
#
#
mirrorselect --server=5 --md5=md5 --output | tee /etc/portage/mirrors.list
# mirrorselect --all --rsync --md5=md5 --output | \
#     awk 'BEGIN {print "GENTOO_MIRRORS=\""} NF {printf "%s ", $3} END {print "\""}' | \
#     tee /etc/portage/mirrors.list
#
if [ $? -ne 0 ]; then
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao tentar atualizar lista de mirrors" >> $LOG_FILE
        sudo -u jkyon notify-send -u critical -i $ICON "Portage" "Mirrors list cannot be updated"
    else
        sudo -u jkyon notify-send -u normal -i $ICON "Portage" "Mirrors list updated sucsessfuly"
    fi
