#!/usr/bin/env bash
# Starts a binding run. Usage: bind.sh <batch-id> <press-temperature-in-celsius>
batch="$1"
temp="$2"
case "$temp" in
  ''|*[!0-9]*)
    echo "bind: press temperature must be a whole number of degrees, got '$temp'" >&2
    exit 2
    ;;
esac
mkdir -p bindery
printf 'batch=%s press=%sC status=bound\n' "$batch" "$temp" > "bindery/$batch.log"
echo "bind: $batch done at ${temp}C"
