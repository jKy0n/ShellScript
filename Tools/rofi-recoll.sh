#!/bin/bash

query=$(rofi -dmenu -p "Search Recoll:")

[[ -z "$query" ]] && exit 0

# Execute the search in Recoll, clean output, get only the path
recollq -t "$query" | sed 's/^file:\/\/\(.*\)/\1/' | rofi -dmenu -i -p "Results:" | xargs -r xdg-open