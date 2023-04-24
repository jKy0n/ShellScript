# Update routine
#
#
#
#
#
#
#
#
#
sudo cpupower frequency-set -g performance &&
sudo emaint sync -A &&
sudo emerge --sync &&
sudo emerge-webrsync &&
sudo emerge -avuND @world &&
sudo emerge --depclean &&
sudo cpupower frequency-set -g ondemand ; 
