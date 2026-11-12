#!/usr/bin/env bash
source "$TM_LIB"

LID=$(tm_recall ledger_id); CID=$(tm_recall card_id)
[[ -n "$LID" && -n "$CID" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "terraform_data" "launch_ledger"' "the ledger must be a terraform_data resource named launch_ledger"
tm_assert_config_lacks 'resource[[:space:]]+"null_resource"' "no null_resource blocks should remain in the code"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*null_resource\.launch_ledger' "record the type change with a moved block"

tm_validate "the configuration does not validate"
TM_MSG="the plan would destroy the ledger instead of converting it" tm_assert_no_destroy
tm_apply

tm_assert_in_state terraform_data.launch_ledger
tm_assert_not_in_state null_resource.launch_ledger "null_resource.launch_ledger is still in state"
NOW=$(tm_state_attr terraform_data.launch_ledger id)
[[ "$NOW" == "$LID" ]] || tm_fail "the ledger ID changed ($LID -> $NOW); the shot cards already print the old one"
[[ "$(tm_state_attr local_file.shot_card id)" == "$CID" ]] || tm_fail "the shot card was rewritten"

TR=$(tm_state_attr terraform_data.launch_ledger triggers_replace)
[[ "$(jq -r '.field' <<<"$TR" 2>/dev/null)" == "Hartley Heath" && "$(jq -r '.engine' <<<"$TR" 2>/dev/null)" == "TB-7" ]] \
  || tm_fail "the ledger's trigger values were lost in the conversion: $TR"

tm_assert_file_equals shots/tb-7.txt "shot card for TB-7 from Hartley Heath, ledger ${LID}"$'\n'
tm_assert_no_changes
tm_pass "null_resource.launch_ledger became terraform_data.launch_ledger with ID ${LID}"
