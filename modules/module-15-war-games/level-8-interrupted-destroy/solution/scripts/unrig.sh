#!/usr/bin/env bash
# Hands a stand's rigging bay back to the venue desk. Usage: unrig.sh <stand>
# Only one unrig at a time may touch the crate manifest, so it takes a lock.
stand="$1"
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
echo "pid=$$ stand=$stand since=$(date +%H:%M:%S)" > "$lock"
echo "$(date +%Y-%m-%dT%H:%M:%S) bay returned stand=$stand" >> crates/unrig.log
rm -f "$lock"
