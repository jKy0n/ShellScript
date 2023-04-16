echo "" &&
neofetch &&
echo "" &&
echo "				BtrFS Filesystem Usage Devices: " &&
echo "" && 
echo "		 ----------		   root:			---------- " &&
echo "" &&
sudo btrfs filesystem show / &&
echo "" &&
echo "		 ----------		   Home:			---------- " &&
echo "" &&
sudo btrfs filesystem show /home &&
echo "" &&
echo "		----------		TimeShift:			---------- " &&
echo "" &&
sudo btrfs filesystem show /run/timeshift/backup/ ;
