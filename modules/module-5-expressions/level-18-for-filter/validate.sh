#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'if[[:space:]]+[a-z_.]*staffed' "keep the filter condition (the 'if' clause) on the staffed flag"
tm_assert_config_has 'min_height_m' "the height threshold must come from var.min_height_m"

tm_apply
tm_assert_output_jq watch_list '. == ["Raven Knob","Tamarack","Grey Rock"]' \
  "watch_list should be the staffed towers at least 25 m tall: Raven Knob, Tamarack, Grey Rock"
tm_assert_output_jq watch_heights '. == {"Raven Knob":31,"Tamarack":25,"Grey Rock":27.5}'
tm_assert_file_equals rosters/tonight.txt "Raven Knob (31 m)
Tamarack (25 m)
Grey Rock (27.5 m)
"

tm_plan_json -var min_height_m=30 -var 'towers=[{name="A",height_m=30,staffed=true},{name="B",height_m=45,staffed=false},{name="C",height_m=29.9,staffed=true},{name="D",height_m=60,staffed=true}]'
jq -e '.planned_values.outputs.watch_list.value == ["A","D"]
  and .planned_values.outputs.watch_heights.value == {"A":30,"D":60}' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with min_height_m = 30 only staffed towers of 30 m or more qualify (A and D); a tower exactly at the minimum counts"
tm_pass "the roster keeps exactly the staffed towers that are tall enough, minimum included"
