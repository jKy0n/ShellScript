#!/usr/bin/env bash
#
# Quick Update routine #
# By jKyon =) #
#
#
sudo cpupower frequency-set -g performance &&
sleep 5 ;
sudo apt-get update &&
sudo apt-get upgrade -y &&
sudo apt-get autoclean &&
sudo apt-get autoremove &&
sleep 30 &&
sudo cpupower frequency-set -g schedutil ;
