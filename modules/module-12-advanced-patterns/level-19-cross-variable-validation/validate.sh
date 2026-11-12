#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'validation[[:space:]]*\{' "write the rules as variable validation blocks"
tm_assert_config_lacks '(pre|post)condition[[:space:]]*\{' "the late resource-level check has to go: the rule belongs on the variables"

tm_validate "the configuration does not validate"

# must accept the defaults and legitimate alternatives (including a full house)
for args in "" "-var guests=40 -var tables=8 -var seats_per_table=5" "-var guests=30" "-var start_hour=9 -var end_hour=10"; do
  # shellcheck disable=SC2086
  code=$(tm_plan_code $args)
  [[ "$code" == "0" || "$code" == "2" ]] || { tm_show_last; tm_fail "a valid combination is rejected (${args:-defaults})"; }
done

# must reject impossible combinations at variable-validation time
expect_rejected() {
  local why="$1"; shift
  local code
  code=$(tm_plan_code "$@")
  [[ "$code" == "1" ]] || tm_fail "accepted: $why"
  grep -q 'Invalid value for variable' "$TM_LAST_OUT" || { tm_show_last; tm_fail "rejected too late (not by variable validation): $why"; }
}
expect_rejected "31 guests at 5 tables of 6" -var guests=31
expect_rejected "30 guests at 4 tables of 7" -var tables=4 -var seats_per_table=7
expect_rejected "50 guests at 7 tables of 7" -var guests=50 -var tables=7 -var seats_per_table=7
expect_rejected "session ending before it starts" -var start_hour=18 -var end_hour=17
expect_rejected "session of zero length" -var start_hour=15 -var end_hour=15

tm_apply
tm_assert_file_equals slam/plan.txt "30 guests at 5 tables of 6, 14:00-17:00"$'\n'
tm_assert_no_changes
tm_pass "impossible seating and times are rejected by variable validation, valid ones pass"
