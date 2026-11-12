#!/usr/bin/env bash
# Hands a marquee's rig back to the site desk. Usage: unrig.sh <marquee>
# Only one unrig at a time may touch the crate manifest, so it takes a lock.
marquee="$1"
mkdir -p crates
lock="crates/manifest.lock"
waited=0
while [ -e "$lock" ]; do
  if [ "$waited" -ge 4 ]; then
    echo "unrig: crates/manifest.lock is held ($(cat "$lock")); refusing to touch the crate manifest" >&2
    exit 4
  fi
  sleep 1; waited=$((waited + 1))
done
echo "pid=$$ marquee=$marquee since=$(date +%H:%M:%S)" > "$lock"
echo "$(date +%Y-%m-%dT%H:%M:%S) rig returned marquee=$marquee" >> crates/unrig.log
rm -f "$lock"
