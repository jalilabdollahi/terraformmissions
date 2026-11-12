#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new west >/dev/null || exit 1
tm_apply
terraform workspace new east >/dev/null || exit 1
tm_apply
# The last apply (east) overwrote the files west wrote earlier.
