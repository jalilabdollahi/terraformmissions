#!/usr/bin/env bash
source "$TM_LIB"

L5=$(tm_recall lane5); L6=$(tm_recall lane6)
[[ -n "$L5" && -n "$L6" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'removed[[:space:]]*\{' "decommission lane 7 with a removed block (the resource block must stay gone)"
tm_assert_config_has 'from[[:space:]]*=[[:space:]]*local_file\.lane_7' "the removed block must point at local_file.lane_7"
tm_assert_config_lacks 'resource[[:space:]]+"local_file"[[:space:]]+"lane_7"' "lane 7 must not come back as a resource"
tm_assert_config_lacks 'destroy[[:space:]]*=[[:space:]]*false' "lane 7 has to be destroyed, not just forgotten"

tm_apply

tm_assert_not_in_state local_file.lane_7 "local_file.lane_7 is still in state"
tm_assert_no_file lanes/lane-7.txt "lanes/lane-7.txt is still on disk: the sheet was forgotten but not destroyed"
tm_assert_file receipts/lane-7.txt "no retirement receipt: the destroy-time provisioner never ran"
tm_assert_file_contains receipts/lane-7.txt "retired" "the receipt does not say the lane was retired"
tm_assert_file_contains receipts/lane-7.txt "lane-7.txt" "the receipt should name the sheet that was destroyed"

[[ "$(tm_state_attr local_file.lane_5 id)" == "$L5" ]] || tm_fail "lane 5 was recreated"
[[ "$(tm_state_attr local_file.lane_6 id)" == "$L6" ]] || tm_fail "lane 6 was recreated"
tm_assert_file_equals lanes/lane-5.txt "lane 5: open"$'\n'
tm_assert_file_equals lanes/lane-6.txt "lane 6: open"$'\n'
tm_assert_no_changes
tm_pass "lane 7's sheet was destroyed, the receipt written and lanes 5 and 6 untouched"
