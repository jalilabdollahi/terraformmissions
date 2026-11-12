#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '\.\.\.[[:space:]]*\}' "group the flights with the ... grouping mode at the end of the map for expression"

tm_apply
tm_assert_output_jq by_carousel '. == {"C1":["SB204","SB311","SB520"],"C2":["KL881","KL112"],"C3":["AE090"]}' \
  "by_carousel should list every flight under its carousel, in arrival order: C1 [SB204, SB311, SB520], C2 [KL881, KL112], C3 [AE090]"
tm_assert_output_jq load '. == {"C1":3,"C2":2,"C3":1}'
tm_assert_file_equals boards/c1.txt "Carousel C1: SB204, SB311, SB520
"
tm_assert_file_equals boards/c3.txt "Carousel C3: AE090
"
STATE=$(terraform state list 2>/dev/null)
[[ "$(grep -c . <<<"$STATE")" == "3" ]] || tm_fail "there should be exactly one announcement per carousel (3)"

tm_plan_json -var 'arrivals=[{flight="X1",carousel="A"},{flight="X2",carousel="A"},{flight="X3",carousel="B"}]'
jq -e '.planned_values.outputs.by_carousel.value == {"A":["X1","X2"],"B":["X3"]}
  and .planned_values.outputs.load.value == {"A":2,"B":1}' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "grouping must work for any arrivals list: X1 and X2 on A, X3 on B"
tm_pass "flights are grouped per carousel in arrival order"
