#!/usr/bin/env bash
source "$TM_LIB"
# The floor staff config has already been applied; its state lives in floor-staff/.
cd floor-staff || exit 1
terraform init -input=false -no-color >"$TM_TMP/staff-init.txt" 2>&1 || { cat "$TM_TMP/staff-init.txt"; exit 1; }
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/staff-apply.txt" 2>&1 || { cat "$TM_TMP/staff-apply.txt"; exit 1; }
exit 0
