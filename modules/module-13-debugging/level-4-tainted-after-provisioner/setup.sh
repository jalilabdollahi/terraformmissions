#!/usr/bin/env bash
source "$TM_LIB"
# First rollout: the provisioner fails, which leaves the object in state, tainted.
terraform apply -auto-approve -input=false -no-color >"$TM_TMP/setup-apply.txt" 2>&1
SHOW=$(terraform state show terraform_data.sprayer_firmware 2>&1)
if [[ "$SHOW" != *tainted* ]]; then
  echo "setup: expected terraform_data.sprayer_firmware to be tainted"; cat "$TM_TMP/setup-apply.txt"; exit 1
fi
tm_record old_id "$(tm_state_attr terraform_data.sprayer_firmware id)"
exit 0
