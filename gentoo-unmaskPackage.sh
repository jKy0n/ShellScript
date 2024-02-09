#!/usr/bin/env sh
echo "$1 ~amd64" | doas tee --append /etc/portage/package.accept_keywords