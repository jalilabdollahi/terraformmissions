#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'max[[:space:]]*\(' "the deepest sample must be computed with max()"
tm_assert_config_has 'min[[:space:]]*\(' "the shallowest sample must be computed with min()"

tm_apply
tm_assert_output deepest_m "90.25"
tm_assert_output shallowest_m "7.75"
tm_assert_output span_m "82.5"
tm_assert_output_jq site_deepest_m '. == {"Camp Ridge":48,"North Col":60.4,"Blue Pass":90.25}' \
  "site_deepest_m should be the deepest sample of each site: Camp Ridge 48, North Col 60.4, Blue Pass 90.25"
tm_assert_file_equals log/summary.txt "samples=9 deepest=90.25m shallowest=7.75m
"

tm_plan_json -var 'cores={"A"=[3,4],"B"=[250,1.5,9],"C"=[40]}'
jq -e '.planned_values.outputs.deepest_m.value == 250
  and .planned_values.outputs.shallowest_m.value == 1.5
  and .planned_values.outputs.span_m.value == 248.5
  and .planned_values.outputs.site_deepest_m.value == {"A":4,"B":250,"C":40}' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "the depths are not computed from var.cores: another set of sites gives different extremes"
tm_pass "extremes are computed from the sample lists with max()/min() and argument expansion"
