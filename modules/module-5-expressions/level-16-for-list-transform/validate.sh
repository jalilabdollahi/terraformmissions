#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '\[[[:space:]]*for[[:space:]]' "build the lists with for expressions over the variables"

tm_apply
tm_assert_output_jq jar_labels '. == ["01-LAVENDER","02-CEDAR","03-FIG & HONEY"]' \
  "jar_labels should number from 01 in list order with the scent upper-cased: 01-LAVENDER, 02-CEDAR, 03-FIG & HONEY"
tm_assert_output_jq pour_sheet '. == ["Lavender: 450 g","Cedar: 600 g","Fig & Honey: 300 g"]'
tm_assert_output total_wax_g 1350
tm_assert_file_equals sheets/pouring.txt "Lavender: 450 g
Cedar: 600 g
Fig & Honey: 300 g
Total: 1350 g
"

tm_plan_json -var 'scents=["Pine","Rose"]' -var 'batches=[{scent="Pine",wax_g=125},{scent="Rose",wax_g=75.5}]'
jq -e '.planned_values.outputs.jar_labels.value == ["01-PINE","02-ROSE"]
  and .planned_values.outputs.pour_sheet.value == ["Pine: 125 g","Rose: 75.5 g"]
  and .planned_values.outputs.total_wax_g.value == 200.5' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "the labels and sheet must be derived from whatever scents and batches are supplied"
tm_pass "the for expressions use their iterators correctly (index first, value second)"
