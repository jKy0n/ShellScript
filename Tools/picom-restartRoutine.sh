#!/usr/bin/env bash
#
#
#
# NOTE: Version 3:                                                                                                                  
#                                                                                                                                   
#                                                                                                                                   
LOG_FILE="/home/jkyon/.logs/picom-restarting.log"                                                                                   
ICON="/usr/share/icons/Papirus/48x48/devices/display.svg"                                                                           
#                                                                                                                                   
#                                                                                                                                   
picom_ativo(){
#
killall picom && sleep 1 && picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.logs/picom.log --daemon --backend glx 
    if [ $? -ne 0 ]; then                                                                                                           
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao tentar reiniciar o Picom" >> $LOG_FILE                                      
        sudo -u jkyon notify-send -u critical -i $ICON "Picom" "Error ao tentar reiniciar o Picom"                                  
    else                                                                                                                            
        sudo -u jkyon notify-send -u normal -i $ICON "Picom" "Compositor reiniciado"                                                
    fi                                                                                                                              
  }
#
#
picom_inativo(){
#
picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.logs/picom.log --daemon --backend glx  
    if [ $? -ne 0 ]; then                                                                                                            
        echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao tentar iniciar o Picom" >> $LOG_FILE                                       
        sudo -u jkyon notify-send -u critical -i $ICON "Picom" "Error ao tentar iniciar o Picom"                                   
    else                                                                                                                             
        sudo -u jkyon notify-send -u normal -i $ICON "Picom" "Compositor iniciado"                                                 
    fi                                                                                                                               
  }                                                                                                                                  
#
#
#
pgrep -x "picom" > /dev/null
    if [ $? -ne 0 ]; then
        picom_inativo
    else
        picom_ativo
    fi
#
#
#
# NOTE: Version 2:
#
#
# LOG_FILE="/home/jkyon/.logs/picom-restarting.log"
# ICON="/usr/share/icons/Papirus/48x48/devices/display.svg"
# #
# #
# killall picom && sleep 3 && \
# picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx
#     if [ $? -ne 0 ]; then
#         echo "$(date +'[%Y-%m-%d - %H:%Mh]') - Error ao tentar reiniciar o Picom" >> $LOG_FILE
#         sudo -u jkyon notify-send -u critical -i $ICON "Picom" "Error ao tentar reiniciar o Picom"
#     else
#         sudo -u jkyon notify-send -u normal -i $ICON "Picom" "Compositor reiniciado"
#     fi
#
#
#
#
#
# NOTE: Version 1:
#
#
# (killall picom &&    \
# sleep 3 &&          \
# picom --config /home/jkyon/.config/picom/picom.conf --log-file /home/jkyon/.dotfiles/.config/picom/picom.log --daemon --backend glx) | \
# date +'[%d-%m-%Y %H:%Mh]' >> /home/jkyon/.logs/crontab-jkyon.log
#
#
# notify-send -u critical "Picom" "Now restarted\! =)"
