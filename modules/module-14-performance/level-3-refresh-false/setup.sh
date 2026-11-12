#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
# A technician removes one setpoint file by hand.
rm -f freezer/ice-core-b.txt
[[ ! -e freezer/ice-core-b.txt ]] || exit 1
