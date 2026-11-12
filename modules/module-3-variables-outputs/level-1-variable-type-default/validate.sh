#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform validate fails — read the error: it names the variable and the line"
tm_apply
tm_assert_output_jq machine_count 'type == "number" and . == 3' \
  "machine_count should be the number 3 (three machines)"
tm_assert_output_jq daily_cycles '. == 120' "daily_cycles should be 3 machines x 40 cycles = 120"
tm_assert_file_contains out/wash-plan.txt "3 machines -> 120 cycles" "wash-plan.txt does not show 3 machines and 120 cycles"

# the arithmetic must be live: a different machine count has to flow through
tm_plan_json -var machine_count=5
[[ "$(jq -r '.planned_values.outputs.daily_cycles.value' "$TM_TMP/plan.json")" == "200" ]] \
  || tm_fail "daily_cycles does not follow machine_count — is the number hard-coded?"
tm_pass "machine_count is a real number and the wash plan adds up to 120 cycles"
