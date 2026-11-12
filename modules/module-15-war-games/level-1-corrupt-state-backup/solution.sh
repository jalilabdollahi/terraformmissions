#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/terraform.tfstate.corrupt"
cp terraform.tfstate.backup terraform.tfstate
SERIAL=$(sed -n 's/^ *receiver_serial *= *RX-//p' calibration/dish-west.cfg)
terraform import 'random_id.receiver["west"]' "$SERIAL"
terraform apply -auto-approve
