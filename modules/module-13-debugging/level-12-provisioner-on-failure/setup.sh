#!/usr/bin/env bash
source "$TM_LIB"
# The "green" run: the script fails, Terraform shrugs, the object is recorded as created.
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/setup-apply.txt" 2>&1 \
  || { cat "$TM_TMP/setup-apply.txt"; exit 1; }
tm_record old_id "$(tm_state_attr terraform_data.develop_batch id)"
[[ ! -e darkroom/batch-114.log ]] || { echo "setup: log should not exist yet"; exit 1; }
exit 0
