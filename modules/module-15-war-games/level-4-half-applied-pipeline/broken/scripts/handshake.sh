#!/usr/bin/env bash
# Registers a drying run with the kiln controller. Usage: handshake.sh <lot> <kiln> <tag>
lot="$1"; kiln="$2"; tag="$3"
here="$(cd "$(dirname "$0")" && pwd)"
if ! grep -qx -- "$kiln" "$here/kilns.allow"; then
  echo "handshake: kiln '$kiln' is not on the controller allow-list" >&2
  exit 3
fi
mkdir -p ledger
echo "$(date +%Y-%m-%dT%H:%M:%S) lot=$lot kiln=$kiln tag=$tag ACK" >> ledger/handshakes.log
