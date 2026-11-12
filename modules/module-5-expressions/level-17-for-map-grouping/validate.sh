#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '\.\.\.[[:space:]]*\}' "group the plates with the ... grouping mode at the end of the map for expression"

tm_apply
tm_assert_output_jq by_belt '. == {"B1":["TUNA-1","TUNA-2","TUNA-3"],"B2":["EEL-1","EEL-2"],"B3":["ROE-1"]}' \
  "by_belt should list every plate under its belt, in serving order: B1 [TUNA-1, TUNA-2, TUNA-3], B2 [EEL-1, EEL-2], B3 [ROE-1]"
tm_assert_output_jq load '. == {"B1":3,"B2":2,"B3":1}'
tm_assert_file_equals boards/b1.txt "Belt B1: TUNA-1, TUNA-2, TUNA-3
"
tm_assert_file_equals boards/b3.txt "Belt B3: ROE-1
"
STATE=$(terraform state list 2>/dev/null)
[[ "$(grep -c . <<<"$STATE")" == "3" ]] || tm_fail "there should be exactly one belt board per belt (3)"

tm_plan_json -var 'plates=[{plate="X1",belt="A"},{plate="X2",belt="A"},{plate="X3",belt="B"}]'
jq -e '.planned_values.outputs.by_belt.value == {"A":["X1","X2"],"B":["X3"]}
  and .planned_values.outputs.load.value == {"A":2,"B":1}' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "grouping must work for any plates list: X1 and X2 on A, X3 on B"
tm_pass "plates are grouped per belt in serving order"
