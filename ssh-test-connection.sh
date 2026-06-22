#!/usr/bin/env bash

hosts=(
  "theseusmachine:TheseusMachine"
  "viamar-pc:Viamar-PC"
  "crisnote:CrisNote"
  "builder:Builder"
)

for item in "${hosts[@]}"; do
  host="${item%%:*}"
  name="${item#*:}"

  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$host" true 2>/dev/null; then
    echo "✅ $name connected!"
  else
    echo "❌ $name not reachable!"
  fi
done