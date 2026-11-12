#!/usr/bin/env bash
# Ships a bottling run: refuses to leave without the run manifest.
echo "ship: checking for the manifest"
if [ ! -f bottling/manifest.txt ]; then
  echo "ship: bottling/manifest.txt is missing - nothing to ship" >&2
  exit 1
fi
mkdir -p ship
printf 'shipped; %s\n' "$(head -n 1 bottling/manifest.txt)" > ship/ship.log
echo "ship: done"
