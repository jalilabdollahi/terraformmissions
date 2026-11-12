#!/usr/bin/env bash
source "$TM_LIB"
# The depot team's config has already been applied; its state lives in depot-team/state/.
cd depot-team || exit 1
terraform init -input=false -no-color >"$TM_TMP/depot-init.txt" 2>&1 || { cat "$TM_TMP/depot-init.txt"; exit 1; }
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/depot-apply.txt" 2>&1 || { cat "$TM_TMP/depot-apply.txt"; exit 1; }
exit 0
