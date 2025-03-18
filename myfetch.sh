#!/usr/bin/env bash
#
echo "" &&
neofetch &&
echo "" &&
echo "				BtrFS Filesystem Usage Devices: " &&
echo "" && 
echo "		 ----------		   root:			---------- " &&
echo "" &&
doas btrfs filesystem show / &&
echo "" &&
echo "		 ----------		   Home:			---------- " &&
echo "" &&
doas btrfs filesystem show /home &&
echo "" &&
echo "		----------		TimeShift:			---------- " &&
echo "" &&
doas btrfs filesystem show /media/backup ;
