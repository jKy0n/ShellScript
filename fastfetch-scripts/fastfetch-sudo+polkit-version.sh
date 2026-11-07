#!/usr/bin/env bash
#
sudo_version=$(sudo --version | awk 'NR==1 {print $1, $NF}')
polkit_version=$(pkexec --version | awk 'NR==1 {print $1, $3}')
echo "$sudo_version + $polkit_version"