#!/usr/bin/env bash
# Flashes a firmware image onto a van's sprayer controller (simulated).
# Needs: VAN_ID, FIRMWARE, IMAGE_DIR
image="$IMAGE_DIR/firmware-$FIRMWARE.bin"
echo "flash: van=$VAN_ID firmware=$FIRMWARE"
if [ ! -f "$image" ]; then
  echo "flash: image file not found: $image" >&2
  exit 3
fi
mkdir -p flashed
printf 'van=%s firmware=%s sha=%s\n' "$VAN_ID" "$FIRMWARE" "$(cksum < "$image" | cut -d' ' -f1)" > "flashed/$VAN_ID.stamp"
echo "flash: done"
