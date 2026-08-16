#!/usr/bin/env sh
echo "$1 $2" | doas tee --append /etc/portage/package.use/$1