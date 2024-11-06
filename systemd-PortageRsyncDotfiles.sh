#!/usr/bin/env bash
#
#
#
rsync -av --delete --exclude='/etc/ssh/*' --exclude='/etc/udisks2/*' /etc /home/jkyon/.theseusMachine-core/
