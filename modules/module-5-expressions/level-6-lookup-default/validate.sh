#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'standard_batch_kg' "the fallback must come from var.standard_batch_kg"
tm_assert_config_lacks 'lookup[[:space:]]*\([^)]*,[[:space:]]*[0-9]+[[:space:]]*\)' "do not hard-code the fallback number inside lookup()"

tm_apply
tm_assert_output_jq cook_order '. == {"regular":28,"low_salt":3,"pureed":1.2,"gluten_free":3}' \
  "cook_order should give regular 28, low_salt 3, pureed 1.2, gluten_free 3"
tm_assert_output total_kg "35.2"
tm_assert_file_equals board/diets.txt "gluten_free: 3 kg
low_salt: 3 kg
pureed: 1.2 kg
regular: 28 kg
"

# Different standard batch and different diets.
tm_plan_json -var standard_batch_kg=7 -var 'diets=["soft","halal","pureed"]'
jq -e '.planned_values.outputs.cook_order.value == {"soft":9.5,"halal":7,"pureed":1.2}
  and .planned_values.outputs.total_kg.value == 17.7' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "unlisted diets must get var.standard_batch_kg and listed ones their own batch (soft 9.5, halal 7, pureed 1.2)"
tm_pass "listed diets keep their batch and every other diet falls back to the standard one"
