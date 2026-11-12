#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks 'output[[:space:]]+"[a-z_]+"[[:space:]]*\{[^}]*value[[:space:]]*=[[:space:]]*("|[0-9])' "outputs must read the nested data, not repeat it"
tm_assert_config_has 'var\.habitats' "outputs must be derived from var.habitats"

tm_apply
tm_assert_output savanna_capacity "12"
tm_assert_output aviary_lead_keeper "Mei"
tm_assert_output reptile_head_keeper "Omar"
tm_assert_output total_capacity "60"
[[ $(ls roster | wc -l | tr -d ' ') == "3" ]] || tm_fail "expected 3 roster files"

# The outputs must follow the data, so feed a different roster.
tm_plan_json -var 'habitats={
  savanna={diet="grass",enclosure={capacity=3,keepers=["Zed"]}},
  aviary={diet="seeds",enclosure={capacity=5,keepers=["Yui","Xan"]}},
  reptile_house={diet="insects",enclosure={capacity=2,keepers=["Wes"]}}
}'
for pair in "savanna_capacity=3" "aviary_lead_keeper=Yui" "reptile_head_keeper=Wes" "total_capacity=10"; do
  n=${pair%%=*}; v=${pair#*=}
  got=$(jq -r --arg n "$n" '.planned_values.outputs[$n].value' "$TM_TMP/plan.json")
  [[ "$got" == "$v" ]] || tm_fail "output $n = '$got' with a different roster; expected '$v' — it must be derived from var.habitats"
done
tm_pass "all three outputs walk the nested habitat structure correctly"
