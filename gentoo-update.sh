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
sudo emerge-webrsync &&
sudo emerge --sync &&
sudo emaint sync --all &&
sudo emerge -avuND @world &&
sudo emerge --depclean &&
sudo cpupower frequency-set -g ondemand ; 
