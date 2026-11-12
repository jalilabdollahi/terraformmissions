#!/usr/bin/env bash
source "$TM_LIB"

for fn in setunion setintersection setsubtract; do
  tm_assert_config_has "$fn[[:space:]]*\\(" "use $fn() — the sign-up sheets are sets of names"
done

tm_apply
tm_assert_output_jq everyone '. == ["Anwen","Bryn","Cerys","Dilys","Gethin","Rhys"]' \
  "everyone should list each singer once (Anwen, Bryn, Cerys, Dilys, Gethin, Rhys)"
tm_assert_output_jq regulars '. == ["Anwen","Bryn","Gethin"]' \
  "regulars are the singers on BOTH the concert and rehearsal sheets: Anwen, Bryn, Gethin"
tm_assert_output_jq need_a_robe '. == ["Anwen","Bryn","Rhys"]' \
  "need_a_robe should be the concert singers who do not own a robe: Anwen, Bryn, Rhys"
tm_assert_file_equals lists/robes.txt "Anwen
Bryn
Rhys
"

tm_plan_json -var 'concert_singers=["Ola","Ola","Pim"]' -var 'rehearsal_singers=["Pim","Quin"]' -var 'robe_owners=["Quin"]'
jq -e '.planned_values.outputs.everyone.value == ["Ola","Pim","Quin"]
  and .planned_values.outputs.regulars.value == ["Pim"]
  and .planned_values.outputs.need_a_robe.value == ["Ola","Pim"]' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "on other sheets the results must be: everyone [Ola, Pim, Quin], regulars [Pim], need_a_robe [Ola, Pim]"
tm_pass "union, intersection and difference are computed with the right set functions and argument order"
