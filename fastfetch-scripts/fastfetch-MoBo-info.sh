#!/usr/bin/env bash

echo "$(cat /sys/devices/virtual/dmi/id/board_vendor) $(cat /sys/devices/virtual/dmi/id/board_name) ($(cat /sys/devices/virtual/dmi/id/board_version)) - BIOS $(cat /sys/devices/virtual/dmi/id/bios_version)"
