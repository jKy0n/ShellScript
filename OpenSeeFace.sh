#!/usr/bin/env bash
#
#
# NOTE: 
#
#
cd /home/jkyon/gitApps/OpenSeeFace 
source env/bin/activate
python facetracker.py -c 0 -W 1280 -H 720 --discard-after 0 --scan-every 0 --no-3d-adapt 1 --max-feature-updates 900
