#!/usr/bin/env bash
source "$TM_LIB"
# The stage crew config has already been applied; its state lives in stage-crew/.
cd stage-crew || exit 1
terraform init -input=false -no-color >"$TM_TMP/crew-init.txt" 2>&1 || { cat "$TM_TMP/crew-init.txt"; exit 1; }
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/crew-apply.txt" 2>&1 || { cat "$TM_TMP/crew-apply.txt"; exit 1; }
exit 0
