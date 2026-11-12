#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '\?[^:]*:' "keep the conditional expressions — the pass depends on two flags"

tm_apply
tm_assert_output_jq zips '. == ["canopy","gorge","valley"]' "in peak season three zip lines are open: canopy, gorge, valley"
tm_assert_output_jq discount_factor 'type == "number" and . == 1' "discount_factor must be the NUMBER 1 for a full-price pass"
tm_assert_output_jq price_eur 'type == "number" and . == 64' "price_eur should be the number 64"
tm_assert_file_equals desk/pass.txt "Zips: canopy, gorge, valley
Price: 64 EUR
"

check_case() {   # peak junior zips factor price
  tm_plan_json -var "peak_season=$1" -var "junior=$2" -var base_price_eur=80
  jq -e --argjson zips "$3" --argjson f "$4" --argjson p "$5" '
      .planned_values.outputs.zips.value == $zips
      and (.planned_values.outputs.discount_factor.value | type == "number" and . == $f)
      and (.planned_values.outputs.price_eur.value | type == "number" and . == $p)' "$TM_TMP/plan.json" >/dev/null \
    || tm_fail "peak_season=$1 junior=$2 base 80 should give zips $3, discount_factor $4 and price $5 (all numbers/lists, no strings)"
}
check_case true  true  '["canopy","gorge","valley"]' 0.5 40
check_case false false '["canopy"]' 1 80
check_case false true  '["canopy"]' 0.5 40
tm_pass "both branches of every conditional have the same type, for every flag combination"
