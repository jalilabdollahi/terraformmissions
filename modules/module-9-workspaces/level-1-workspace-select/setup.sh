#!/usr/bin/env bash
source "$TM_LIB"
# Workspaces exist for both environments, but the last apply happened in "default".
terraform workspace new staging >/dev/null || exit 1
terraform workspace new prod >/dev/null || exit 1
terraform workspace select default >/dev/null || exit 1
tm_apply
