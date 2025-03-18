#! /usr/bin/env bash
#
cd /opt/steamcmd/ &&
./steamcmd.sh +login anonymous +force_install_dir /home/satisfactory-server/server +app_update 1690800 validate +quit &&
cd /home/jkyon/.steam/steam/steamapps/common/SatisfactoryDedicatedServer/ &&
sh FactoryServer.sh
