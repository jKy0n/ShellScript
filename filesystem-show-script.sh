echo "" &&
echo "" &&
echo "		  BtrFS Filesystem Usage Devices:			" &&
echo "" && 
echo "	----------		root:		----------	" &&
echo "" &&
sudo btrfs filesystem show / &&
echo "" &&
echo "	----------		home:		----------	" &&
echo "" &&
sudo btrfs filesystem show /home &&
echo "" &&
echo "	----------	    TimeShift:		----------	" &&
echo "" &&
sudo btrfs filesystem show /run/timeshift/backup &&
echo ""