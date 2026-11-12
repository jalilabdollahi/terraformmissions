#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
# A technician removes one setpoint file by hand.
rm -f chiller/yoghurt-b.txt
[[ ! -e chiller/yoghurt-b.txt ]] || exit 1
