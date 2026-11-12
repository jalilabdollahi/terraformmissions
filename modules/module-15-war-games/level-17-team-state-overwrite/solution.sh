#!/usr/bin/env bash
source "$TM_LIB"
cp terraform.tfstate "$TM_TMP/overwritten.tfstate"
terraform state push recovery/fenwick-state-tue-1200.json
BAY=$(sed -n 's/.*quarantine_bay: Creation complete.*\[id=\([0-9]*\)\].*/\1/p' recovery/ci-run-217-apply.log)
terraform import random_integer.quarantine_bay "$BAY,1,60"
terraform apply -auto-approve
