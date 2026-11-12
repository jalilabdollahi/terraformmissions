#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "terraform_data" "batch_record"' "terraform_data.batch_record must stay"
tm_assert_config_has 'triggers_replace[[:space:]]*=[[:space:]]*\[var\.batch_code\]' "keep the triggers_replace on var.batch_code"
tm_assert_config_has '^[[:space:]]*input[[:space:]]*=' "the record must be stored through input"
tm_apply
INPUT_BATCH=$(terraform show -json 2>/dev/null | jq -r '.values.root_module.resources[] | select(.address=="terraform_data.batch_record") | .values.input.batch // empty')
[[ "$INPUT_BATCH" == "HO-0412" ]] || tm_fail "terraform_data.batch_record has no input record with batch HO-0412"
tm_assert_file_equals cave/maturation.log "batch=HO-0412 wheels=36
"
tm_assert_output wheel_count 36
# the record must follow its variable, and the replacement trigger must work
ID1=$(tm_state_attr terraform_data.batch_record id)
tm_apply -var batch_code=HO-0999
tm_assert_file_equals cave/maturation.log "batch=HO-0999 wheels=36
" "the log did not follow var.batch_code"
ID2=$(tm_state_attr terraform_data.batch_record id)
[[ "$ID1" != "$ID2" ]] || tm_fail "changing the batch code did not replace terraform_data.batch_record (triggers_replace)"
tm_apply
tm_assert_file_equals cave/maturation.log "batch=HO-0412 wheels=36
"
tm_assert_no_changes
tm_pass "record stored via input, read back via output, replaced by triggers_replace"
