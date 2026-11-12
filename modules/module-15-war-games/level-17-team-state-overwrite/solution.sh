#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/overwritten.tfstate"
terraform state push recovery/fenwick-state-tue-1200.json
RACK=$(sed -n 's/.*repair_rack: Creation complete.*\[id=\([0-9]*\)\].*/\1/p' recovery/ci-run-217-apply.log)
terraform import random_integer.repair_rack "$RACK,1,60"
terraform apply -auto-approve
