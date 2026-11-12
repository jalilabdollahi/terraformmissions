#!/usr/bin/env bash
source "$TM_LIB"
# Build the whole stockroom, then reproduce the targeted destroy that went too far.
tm_apply
tm_record seal "$(tm_output_raw rack_seal)"
terraform destroy -target=local_file.costume_register -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1 \
  || { tm_show_last; tm_fail "setup: targeted destroy failed"; }
remaining=$(tm_state_list)
[[ "$remaining" == "random_id.rack_seal" ]] || { echo "setup: unexpected state: $remaining"; exit 1; }
