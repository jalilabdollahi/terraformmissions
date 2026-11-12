#!/usr/bin/env bash
source "$TM_LIB"
# The float warehouse has been running from a single state in monolith/. The three new stacks are scaffolded and initialised but empty.
cd "$WORKSPACE/monolith" || tm_fail "monolith/ missing"
tm_init "monolith init failed"
TM_MSG="monolith apply failed" tm_apply
tm_record dock_key "$(tm_state_attr random_id.dock_key hex)"
tm_record capacity "$(tm_state_attr random_integer.rider_capacity result)"
tm_record float_main "$(tm_state_attr 'random_id.float_serial["main"]' hex)"
tm_record float_annex "$(tm_state_attr 'random_id.float_serial["annex"]' hex)"
tm_record signup "$(tm_state_attr random_uuid.signup_ns result)"
tm_record gold "$(tm_state_attr 'random_integer.bead_series["gold"]' result)"
tm_record silver "$(tm_state_attr 'random_integer.bead_series["silver"]' result)"
tm_record bead_ledger "$(tm_state_attr local_file.bead_ledger id)"
tm_record light_key "$(tm_state_attr random_id.rig_key hex)"
tm_record enc_a "$(tm_state_attr 'terraform_data.controller["a"]' id)"
tm_record enc_b "$(tm_state_attr 'terraform_data.controller["b"]' id)"
tm_record cue_sheet "$(tm_state_attr local_file.cue_sheet id)"
for d in warehouse krewes lighting; do
  cd "$WORKSPACE/$d" || tm_fail "$d/ missing"
  tm_init "$d init failed"
done
