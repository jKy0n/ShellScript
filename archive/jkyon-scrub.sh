#
#
#
#		Script for BtrFS Scrub maintenance routine
#
#
#
#
#	WARNING: This routine runs TimeShift scrub first and parallel at root and home!
#
#
#
#
echo "" &&
echo "" &&
echo "               ---------               Scrub TimeShift:                --------- " &&
echo "" &&
sudo btrfs scrub start -Bd /run/timeshift/backup ;
echo "" &&
echo "" &&
echo "               ---------               Scrub root:             --------- " &&
echo "" &&
sudo btrfs scrub start -Bd / &&
echo "" &&
echo "" &&
echo "               ---------               Scrub home:             --------- " &&
echo "" &&
sudo btrfs scrub start -Bd /home &&
echo "" &&
echo "" &&
echo ""