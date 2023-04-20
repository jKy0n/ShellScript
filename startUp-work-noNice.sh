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
#nice -n 16 xpad &
firefox &
sleep 3 &&
vscode &
~/.joplin/Joplin.AppImage &
thunderbird &
sleep 3 &&
spotify &
discord &
#nice -n 5 rambox &
sleep 4m &&
sudo cpupower frequency-set -g ondemand ;
