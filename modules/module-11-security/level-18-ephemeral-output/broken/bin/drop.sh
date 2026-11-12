#!/usr/bin/env bash
# Dead-drop for the night courier: leaves the session token where the courier's app will pick it up.
here="$(cd "$(dirname "$0")/.." && pwd)"
umask 077
mkdir -p "$here/drop"
printf '%s' "${SESSION_TOKEN:-}" > "$here/drop/session.token"
echo "courier: ${COURIER_ROUTE:-unknown}" > "$here/drop/receipt.txt"
echo "token_length: ${#SESSION_TOKEN}" >> "$here/drop/receipt.txt"
