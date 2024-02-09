#!/usr/bin/env bash
#
echo '{
  "name": "'"$1"'",
  "nice": 0,
  "ioclass": "none",
  "ionice": 0,
  "sched": "other",
  "sched_param": 0,
  "cgroup": "none"
}' | doas tee /etc/ananicy.d/$1.rules