#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/terraform.tfstate.corrupt"
cp terraform.tfstate.backup terraform.tfstate
SERIAL=$(sed -n 's/^ *trigger_serial *= *TG-//p' calibration/station-west.cfg)
terraform import 'random_id.trigger["west"]' "$SERIAL"
terraform apply -auto-approve
