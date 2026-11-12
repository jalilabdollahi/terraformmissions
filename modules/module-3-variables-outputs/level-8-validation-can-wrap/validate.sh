#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'can\(' "the condition should use can() to turn a regex failure into false"
tm_assert_config_has 'validation[[:space:]]*\{' "keep the validation block"

tm_apply
tm_assert_output major "3"
tm_assert_output minor "12"
tm_assert_file_contains release/HEADER.md "Spoke & Pedal v3.12" "the release header is wrong"

tm_plan_json -var 'release_tag=v10.0'
[[ "$(jq -r '.planned_values.outputs.major.value' "$TM_TMP/plan.json")" == "10" ]] \
  || tm_fail "a valid tag (v10.0) was rejected"

for bad in "3.12" "release-3" "v3" "v3.x"; do
  if terraform plan -no-color -input=false -var "release_tag=$bad" >"$TM_LAST_OUT" 2>&1; then
    tm_fail "the tag '$bad' should have been rejected"
  fi
  if grep -q "Invalid function argument" "$TM_LAST_OUT"; then
    tm_show_last
    tm_fail "'$bad' makes the validation condition itself crash with a regex error instead of failing cleanly with the friendly message"
  fi
  grep -q "Release tags must look like" "$TM_LAST_OUT" \
    || { tm_show_last; tm_fail "'$bad' was rejected, but not with the variable's friendly error_message"; }
done
tm_pass "malformed tags now fail with the friendly message instead of a regex crash"
