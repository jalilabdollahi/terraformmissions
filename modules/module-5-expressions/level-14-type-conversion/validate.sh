#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'tonumber[[:space:]]*\(' "the times must be converted with tonumber()"
tm_assert_config_has 'can[[:space:]]*\(|try[[:space:]]*\(' "times that are not numbers (DNF, DSQ) need a guard such as can() or try()"

tm_apply
tm_assert_output_jq finishers '. == {"Mika":12.5,"Dara":13.1,"Noor":11.9}' \
  "finishers should be Mika 12.5, Dara 13.1, Noor 11.9 (decimal comma and stray space handled, DNF/DSQ left out)"
tm_assert_output_jq no_time '. == ["Arlo","Luka"]' "no_time should list the cubers without a numeric time: Arlo, Luka"
tm_assert_output winner Noor
tm_assert_output fastest_seconds 11.9
tm_assert_file_equals board/results.txt "Dara: 13.1 sec
Mika: 12.5 sec
Noor: 11.9 sec
Arlo: no time
Luka: no time
"

tm_plan_json -var 'raw_times={Alpha="9,75",Bravo=" 10 ",Charlie="ret",Delta="9.7"}'
jq -e '.planned_values.outputs.finishers.value == {"Alpha":9.75,"Bravo":10,"Delta":9.7}
  and .planned_values.outputs.no_time.value == ["Charlie"]
  and .planned_values.outputs.winner.value == "Delta"
  and .planned_values.outputs.fastest_seconds.value == 9.7' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "for other raw times the finishers, no_time list and winner must be recomputed (9,75 means 9.75; 'ret' is not a time)"
tm_pass "messy time strings are normalized, non-numeric entries are set aside, and the winner is computed"
