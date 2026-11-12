#!/usr/bin/env bash
source "$TM_LIB"

L5=$(tm_recall target5); L6=$(tm_recall target6)
[[ -n "$L5" && -n "$L6" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'removed[[:space:]]*\{' "decommission target 7 with a removed block (the resource block must stay gone)"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*local_file\.target_7' "the removed block must point at local_file.target_7"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"target_7"' "target 7 must not come back as a resource"
tm_assert_config_lacks 'destroy[[:space:]]*=[[:space:]]*false' "target 7 has to be destroyed, not just forgotten"

tm_apply

tm_assert_not_in_state local_file.target_7 "local_file.target_7 is still in state"
tm_assert_no_file targets/target-7.txt "targets/target-7.txt is still on disk: the scorecard was forgotten but not destroyed"
tm_assert_file receipts/target-7.txt "no retirement receipt: the destroy-time provisioner never ran"
tm_assert_file_contains receipts/target-7.txt "retired" "the receipt does not say the target was retired"
tm_assert_file_contains receipts/target-7.txt "target-7.txt" "the receipt should name the scorecard that was destroyed"

[[ "$(tm_state_attr local_file.target_5 id)" == "$L5" ]] || tm_fail "target 5 was recreated"
[[ "$(tm_state_attr local_file.target_6 id)" == "$L6" ]] || tm_fail "target 6 was recreated"
tm_assert_file_equals targets/target-5.txt "target 5: open"$'\n'
tm_assert_file_equals targets/target-6.txt "target 6: open"$'\n'
tm_assert_no_changes
tm_pass "target 7's scorecard was destroyed, the receipt written and targets 5 and 6 untouched"
