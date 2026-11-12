#!/usr/bin/env bash
source "$TM_LIB"

tm_apply
# cast is a MAP: puppeteers are listed in role-key order (dragon, fox, queen), repeats removed.
tm_assert_output_jq puppeteers '. == ["Odile","Bram"]' \
  "puppeteers should be each puppeteer once, in role order: dragon (Odile), fox (Bram), queen (Odile) -> Odile, Bram"
tm_assert_output_jq crew_names '. == ["Wren","Pip"]'
tm_assert_output_jq understudies '. == []' "with no understudy the list must be empty"
tm_assert_output total_strings 30
tm_assert_file_equals programme/tonight.txt "Puppeteers: Odile, Bram
Crew: Wren, Pip
Understudy: 
"

tm_plan_json -var 'cast={zebra={puppeteer="Kit",strings=3},ant={puppeteer="Lou",strings=5}}' \
  -var 'crew=[{name="Ro",job="stage"}]' -var 'understudy={name="Sol"}'
jq -e '.planned_values.outputs.puppeteers.value == ["Lou","Kit"]
  and .planned_values.outputs.crew_names.value == ["Ro"]
  and .planned_values.outputs.understudies.value == ["Sol"]
  and .planned_values.outputs.total_strings.value == 8' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "for another cast (ant=Lou/5 strings, zebra=Kit/3), crew and an understudy the outputs must be recomputed: puppeteers [Lou, Kit], total 8, understudies [Sol]"
tm_pass "the map is looped with for/values(), while splat is kept for the list and the optional object"
