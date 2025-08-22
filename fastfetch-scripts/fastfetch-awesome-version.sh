#!/usr/bin/env bash
#
awesome_version=$(awesome --version 2>&1 | awk 'NR==1 {print $1, $2}')
echo "$awesome_version (X11)"