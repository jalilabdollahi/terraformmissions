#!/usr/bin/env bash
# Starts a film developing run. Usage: develop.sh <batch-id> <bath-temperature-in-celsius>
batch="$1"
temp="$2"
case "$temp" in
  ''|*[!0-9]*)
    echo "develop: bath temperature must be a whole number of degrees, got '$temp'" >&2
    exit 2
    ;;
esac
mkdir -p darkroom
printf 'batch=%s bath=%sC status=developed\n' "$batch" "$temp" > "darkroom/$batch.log"
echo "develop: $batch done at ${temp}C"
