# Snapper SnapShots Preview Script
#
#
#
#
#
#
#
#
#
echo "" &&
sudo ls -a /.snapshots &&
echo "" &&
echo "" &&
sudo sh ~/ShellScript/btrfs-du.sh / &&
echo "" &&
echo "" &&
snapper list -a ;