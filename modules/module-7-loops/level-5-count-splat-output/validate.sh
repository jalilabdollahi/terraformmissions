#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_output closure_count "4"
tm_assert_output_jq closure_paths 'type == "array" and length == 4' "closure_paths must be a list holding all four closure paths"
tm_assert_output_jq closure_paths '[.[] | split("/") | last] == ["harbour-heist.txt","rooftop-chase.txt","diner-scene.txt","alley-duel.txt"]' \
  "closure_paths should list every closure permit, in production order"
# other inputs: an empty schedule must plan cleanly with an empty list, a longer one with a longer list
tm_plan_json -var 'shoots=[]'
jq -e '.output_changes.closure_paths.after == []' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with no shoots the output should be an empty list (an indexed [0] would crash)"
tm_plan_json -var 'shoots=["a","b","c","d","e","f"]'
jq -e '(.output_changes.closure_paths.after | length) == 6' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with six shoots the output should list six paths"
tm_pass "closure_paths is a full list that follows the number of shoots"
