#!/usr/bin/env bash
source "$TM_LIB"
# Config fixes (module output name, channel reference, variable type) come with the solution overlay.
cp terraform.tfstate "$TM_TMP/corrupt.tfstate"
cp terraform.tfstate.backup terraform.tfstate
FUEL=$(sed -n 's/^fuel //p' out/camp-manifest.txt)
terraform import module.power.random_integer.fuel_litres "$FUEL,200,900"
terraform untaint module.comms.random_id.radio_key
terraform apply -auto-approve
