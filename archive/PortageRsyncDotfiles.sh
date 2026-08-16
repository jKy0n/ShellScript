#!/usr/bin/env bash
#
#
#
# NOTE: Version 2:
#
# Defina as variáveis de caminho e ícone
LOG_FILE="/home/jkyon/.logs/PortageBackup.log"
ICON="/usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg"
#
# 
rsync -avP /etc/fstab ~/.dotfiles/ & rsync -avP /etc/portage ~/.dotfiles/
    if [ $? -ne 0 ]; then 
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao tentar backup das configurações do Portage" >> $LOG_FILE
        sudo -u jkyon notify-send -u critical -i $ICON "Portage" "Failed to backup configs"
    else 
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Backup OK!" >> $LOG_FILE 
        sudo -u jkyon notify-send -u normal -i $ICON "Portage" "Configs backup successfully"
    fi
#
#
#
# NOTE: Version 1:
#
# Commandos do seu script
#(rsync -avP /etc/portage ~/.dotfiles/ & rsync -avP /etc/fstab ~/.dotfiles/) | \
#ts +'[%Y-%m-%d - %H:%Mh]' >> /home/jkyon/.logs/crontab-jkyon.log
#
#
# Enviar notificação
#notify-send -u critical -i /usr/share/icons/Papirus/48x48/apps/distributor-logo-gentoo.svg "System Updater" "Portage backup successfully\! =)" 
