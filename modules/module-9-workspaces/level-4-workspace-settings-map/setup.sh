#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new qa >/dev/null || exit 1
