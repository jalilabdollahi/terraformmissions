#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'merge[[:space:]]*\(' "the labels are maps and should be combined with merge()"
tm_assert_config_has 'concat[[:space:]]*\(' "the allergen lists should be combined with concat()"

tm_apply
tm_assert_output_jq label '. == {"origin":"Assam","grade":"BOP","pack":"100g pouch","steep":"4 min"}' \
  "the blend's own grade (BOP) and pack (100g pouch) must override the house label; origin and steep come from the house label"
tm_assert_output_jq allergens '. == ["nuts","sesame","soy"]' \
  "allergens should be nuts, sesame, soy: house list first, blend additions after, no repeats"
tm_assert_file_equals labels/pack.txt "grade: BOP
origin: Assam
pack: 100g pouch
steep: 4 min
contains: nuts, sesame, soy
"

# Other inputs: overrides still win, order of the list is house-then-blend, repeats are dropped.
tm_plan_json -var 'house_label={origin="Ceylon",grade="FOP",steep="3 min"}' \
  -var 'blend_label={origin="Darjeeling",extra="first flush"}' \
  -var 'house_allergens=["milk"]' -var 'blend_allergens=["gluten","milk"]'
jq -e '.planned_values.outputs.label.value == {"origin":"Darjeeling","grade":"FOP","steep":"3 min","extra":"first flush"}
  and .planned_values.outputs.allergens.value == ["milk","gluten"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "with other inputs the label should be origin Darjeeling (blend wins), grade FOP, steep 3 min, extra 'first flush', and allergens [milk, gluten]"
tm_pass "maps merge with the blend winning, lists concatenate without repeats"
