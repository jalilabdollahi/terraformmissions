#!/usr/bin/env bash
# Pretend uplink handshake for the Brest landing station. It only records what it was given.
here="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$here/logs"
digest="$(printf '%s' "${LANDING_PASSWORD:-}" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.buffer.read()).hexdigest())')"
{
  echo "argv: $*"
  echo "env_digest: $digest"
} > "$here/logs/handshake.log"
