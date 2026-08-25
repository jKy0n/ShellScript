#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo -en "\0prompt\x1frecoll:"
  exit 0
fi
q="$1"
recollq -b -t "$q" | sed 's|^file://||p'