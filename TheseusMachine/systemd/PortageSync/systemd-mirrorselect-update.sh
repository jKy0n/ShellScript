#!/usr/bin/env bash
#
#
# NOTE:
#
#
sudo mirrorselect --server=5 --md5=md5 --output | sudo tee /etc/portage/mirrors.list
