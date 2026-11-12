#!/usr/bin/env bash
# Starts a dry-cleaning run. Usage: clean.sh <batch-id> <wash-temperature-in-celsius>
batch="$1"
temp="$2"
case "$temp" in
  ''|*[!0-9]*)
    echo "clean: wash temperature must be a whole number of degrees, got '$temp'" >&2
    exit 2
    ;;
esac
mkdir -p plant
printf 'batch=%s wash=%sC status=cleaned\n' "$batch" "$temp" > "plant/$batch.log"
echo "clean: $batch done at ${temp}C"
