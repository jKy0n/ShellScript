#!/usr/bin/env bash
#
niri_version=$(niri --version | awk '{print $1, $2}')
noctalia_version=$(noctalia --version | awk '{print "Noctalia", $2}')
session_type="${XDG_SESSION_TYPE:-wayland}"
echo "$niri_version + $noctalia_version ($session_type)"
