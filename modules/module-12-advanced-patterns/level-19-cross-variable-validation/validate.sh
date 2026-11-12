#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'validation[[:space:]]*\{' "write the rules as variable validation blocks"
tm_assert_config_lacks '(pre|post)condition[[:space:]]*\{' "the late resource-level check has to go: the rule belongs on the variables"

tm_validate "the configuration does not validate"

# must accept the defaults and legitimate alternatives (including a full house)
for args in "" "-var students=40 -var benches=8 -var stools_per_bench=5" "-var students=30" "-var start_hour=9 -var end_hour=10"; do
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
expect_rejected "31 students at 5 benches of 6" -var students=31
expect_rejected "30 students at 4 benches of 7" -var benches=4 -var stools_per_bench=7
expect_rejected "50 students at 7 benches of 7" -var students=50 -var benches=7 -var stools_per_bench=7
expect_rejected "class ending before it starts" -var start_hour=18 -var end_hour=17
expect_rejected "class of zero length" -var start_hour=15 -var end_hour=15

tm_apply
tm_assert_file_equals class/plan.txt "30 students at 5 benches of 6, 14:00-17:00"$'\n'
tm_assert_no_changes
tm_pass "impossible seating and times are rejected by variable validation, valid ones pass"
