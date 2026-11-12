#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'index[[:space:]]*\(' "the start position must still be found with index()"
tm_assert_config_has 'contains[[:space:]]*\(|can[[:space:]]*\(|try[[:space:]]*\(' "guard the lookup so an unknown bell cannot crash the plan"

# Unknown start bell (the default, Michael): ring in tower order from the first bell.
tm_apply
tm_assert_output start_index 0
tm_assert_output_jq ringing_order '. == ["Gabriel","Mary","Peter","Thomas","John"]' \
  "when the named bell is not in the tower the peal should start at the first bell"
tm_assert_file_equals sheets/peal.txt "Gabriel > Mary > Peter > Thomas > John
"

# A real bell rotates the order.
tm_plan_json -var start_bell=Peter
jq -e '.planned_values.outputs.start_index.value == 2
  and .planned_values.outputs.ringing_order.value == ["Peter","Thomas","John","Gabriel","Mary"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "starting on Peter should give Peter, Thomas, John, Gabriel, Mary"

# Another unknown name, and another tower.
tm_plan_json -var start_bell=Zed -var 'bells=["Alpha","Beta"]'
jq -e '.planned_values.outputs.start_index.value == 0
  and .planned_values.outputs.ringing_order.value == ["Alpha","Beta"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "an unknown bell must fall back to index 0 for any tower"
tm_plan_json -var start_bell=Beta -var 'bells=["Alpha","Beta"]'
jq -e '.planned_values.outputs.ringing_order.value == ["Beta","Alpha"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "starting on the last bell of a two-bell tower should give Beta, Alpha"
tm_pass "the peal rotates to the named bell, or starts from the first bell when the name is unknown"
