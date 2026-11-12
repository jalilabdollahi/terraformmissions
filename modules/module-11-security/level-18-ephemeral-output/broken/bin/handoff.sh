#!/usr/bin/env bash
# Hand-off for the night taxi rank: leaves the session token where the dispatch app will pick it up.
here="$(cd "$(dirname "$0")/.." && pwd)"
umask 077
mkdir -p "$here/handoff"
printf '%s' "${SESSION_TOKEN:-}" > "$here/handoff/session.token"
echo "taxi: ${TAXI_ROUTE:-unknown}" > "$here/handoff/receipt.txt"
echo "token_length: ${#SESSION_TOKEN}" >> "$here/handoff/receipt.txt"
