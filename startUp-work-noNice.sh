# Quick startUp programs routine #
# By jKyon =) #
#
#
#
#         Without NICE
#
#
#
#
sudo cpupower frequency-set -g performance &&
sleep 5 ;
#sudo apt-get update ;
gnome-system-monitor &
kdeconnect-app &
firefox &
sleep 3 &&
#/opt/sublime_text/sublime_text &
atom &
/home/jkyon/.joplin/Joplin.AppImage &
thunderbird &
xpad &
sleep 3 &&
spotify &
#franz &
rambox &
#sleep 30 &&
#sudo apt-get upgrade -y &&
sleep 4m &&
sudo cpupower frequency-set -g schedutil ;
