#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new pr-142 >/dev/null || exit 1
