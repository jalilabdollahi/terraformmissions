#!/usr/bin/env bash
source "$TM_LIB"
cp main.tf "$TM_TMP/main.tf"
cat > main.tf <<'HCL'
resource "random_string" "bay_label" {
  length  = 8
  special = false
}
resource "random_password" "airlock_pin" {
  length  = 12
  special = false
}
resource "random_integer" "irrigation_zone" {
  min = 1
  max = 64
}
HCL
tm_apply
LABEL=$(tm_state_attr random_string.bay_label result)
PIN=$(tm_state_attr random_password.airlock_pin result)
ZONE=$(tm_state_attr random_integer.irrigation_zone result)
tm_record label "$LABEL"; tm_record pin "$PIN"; tm_record zone "$ZONE"
# Forget all three: they now exist only "in the real world".
terraform state rm random_string.bay_label random_password.airlock_pin random_integer.irrigation_zone >/dev/null
cp "$TM_TMP/main.tf" main.tf
cat > imports.tf <<HCL
# Live objects to adopt. Resource blocks do not exist yet.
import {
  to = random_string.bay_label
  id = "${LABEL}"
}

import {
  to = random_password.airlock_pin
  id = "${PIN}"
}

import {
  to = random_integer.irrigation_zone
  id = "${ZONE},1,64"
}
HCL
