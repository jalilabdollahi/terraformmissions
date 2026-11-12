#!/usr/bin/env bash
# Pretend call to the booking gateway of the Redline kart track. Records what it was given.
here="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$here/receipts"
digest="$(printf '%s' "${GATEWAY_TOKEN:-}" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')"
{
  echo "track: ${TRACK_NAME:-unknown}"
  echo "token_digest: $digest"
} > "$here/receipts/publish.log"
