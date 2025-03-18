#!/usr/bin/env bash
#
	ps -eo comm,rss | \
		awk '/awesome/ { print $2 }' | \
		sed -e 's/...$//' | \
		awk '{sub("$", " MB", $1)}; 1'