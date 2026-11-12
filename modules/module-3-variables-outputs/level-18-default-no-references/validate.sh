#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'default[[:space:]]*=[[:space:]]*"[^"]*\$\{[[:space:]]*var\.' "a variable default cannot refer to other variables — compute it in a local"
tm_assert_config_has 'locals[[:space:]]*\{' "derived values belong in a locals block"
tm_assert_config_has 'variable[[:space:]]+"batch_label"' "batch_label must remain an input so special runs can override it"

tm_apply
tm_assert_output batch_label "Copperkettle-batch"
tm_assert_file_equals labels/batch.txt "Copperkettle-batch (500 L)
"

tm_plan_json -var brewery=Foxglove
[[ "$(jq -r '.planned_values.outputs.batch_label.value' "$TM_TMP/plan.json")" == "Foxglove-batch" ]] \
  || tm_fail "changing brewery should change the default label to 'Foxglove-batch'"

tm_plan_json -var brewery=Foxglove -var batch_label=Anniversary-Ale
[[ "$(jq -r '.planned_values.outputs.batch_label.value' "$TM_TMP/plan.json")" == "Anniversary-Ale" ]] \
  || tm_fail "an explicit batch_label must override the derived default"
tm_pass "the label defaults to <brewery>-batch via a local, and can still be overridden"
