#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace new keep >/dev/null || exit 1
tm_apply
terraform workspace new trial >/dev/null || exit 1
tm_apply
terraform workspace select default >/dev/null || exit 1
