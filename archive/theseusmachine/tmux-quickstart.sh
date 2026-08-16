#! /bin/sh
#
tmux new-session \; \
	send-keys 'nice -n 19 htop' C-m \; \
	split-window -h \; \
	select-pane -t 0 \; \
	split-window -v \; \
	select-pane -t 0 \; \
	split-window -h \; \
	send-keys 'ranger' C-m \; \
	select-pane -t 2 \; \
	send-keys 'fastfetch' C-m \; \
	select-pane -t 3 \; \
