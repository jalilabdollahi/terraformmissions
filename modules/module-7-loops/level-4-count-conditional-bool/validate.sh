#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'type[[:space:]]*=[[:space:]]*bool' "floodlights should be declared as a bool variable"
tm_assert_config_lacks 'floodlights[[:space:]]*(==|!=)' "compare nothing - a real bool needs no == check"
tm_assert_config_has 'floodlights[[:space:]]*=[[:space:]]*true' "terraform.tfvars should switch the floodlights on with a real true"
tm_apply
tm_assert_output_jq lights_on '. == true' "lights_on should be the boolean true"
tm_assert_in_state 'local_file.floodlight_schedule[0]' "the floodlight schedule should exist while the lights are on"
tm_assert_file_contains notices/park.txt "floodlights tonight: ON"
tm_assert_file notices/floodlights.txt
# switch the lights off: the schedule must go, the notice must say OFF
tm_plan_json -var floodlights=false
gone=$(tm_plan_deletes)
grep -qxF 'local_file.floodlight_schedule[0]' <<<"$gone" \
  || tm_fail "with floodlights=false the schedule should be removed; plan deletes: ${gone:-nothing}"
jq -e '[.resource_changes[] | select(.address == "local_file.park_notice") | .change.after.content | contains("tonight: OFF")] == [true]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "with floodlights=false the notice should say OFF"
tm_pass "floodlights is a real bool; count goes 1 -> 0 when it is false"
