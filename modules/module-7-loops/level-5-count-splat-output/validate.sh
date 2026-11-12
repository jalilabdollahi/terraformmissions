#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_output permit_count "4"
tm_assert_output_jq permit_paths 'type == "array" and length == 4' "permit_paths must be a list holding all four permit paths"
tm_assert_output_jq permit_paths '[.[] | split("/") | last] == ["taco-tide.txt","dumpling-dash.txt","waffle-wagon.txt","smoky-sam.txt"]' \
  "permit_paths should list every permit, in truck order"
# other inputs: an empty rally must plan cleanly with an empty list, a longer one with a longer list
tm_plan_json -var 'trucks=[]'
jq -e '.output_changes.permit_paths.after == []' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with no trucks the output should be an empty list (an indexed [0] would crash)"
tm_plan_json -var 'trucks=["a","b","c","d","e","f"]'
jq -e '(.output_changes.permit_paths.after | length) == 6' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with six trucks the output should list six paths"
tm_pass "permit_paths is a full list that follows the number of trucks"
