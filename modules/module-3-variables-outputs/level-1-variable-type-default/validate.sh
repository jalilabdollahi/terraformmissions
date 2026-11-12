#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform validate fails — read the error: it names the variable and the line"
tm_apply
tm_assert_output_jq oven_count 'type == "number" and . == 3' \
  "oven_count should be the number 3 (three ovens)"
tm_assert_output_jq daily_loaves '. == 120' "daily_loaves should be 3 ovens x 40 loaves = 120"
tm_assert_file_contains out/bake-plan.txt "3 ovens -> 120 loaves" "bake-plan.txt does not show 3 ovens and 120 loaves"

# the arithmetic must be live: a different oven count has to flow through
tm_plan_json -var oven_count=5
[[ "$(jq -r '.planned_values.outputs.daily_loaves.value' "$TM_TMP/plan.json")" == "200" ]] \
  || tm_fail "daily_loaves does not follow oven_count — is the number hard-coded?"
tm_pass "oven_count is a real number and the bake plan adds up to 120 loaves"
