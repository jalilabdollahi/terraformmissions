#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'tonumber[[:space:]]*\(' "the times must be converted with tonumber()"
tm_assert_config_has 'can[[:space:]]*\(|try[[:space:]]*\(' "times that are not numbers (DNF, DSQ) need a guard such as can() or try()"

tm_apply
tm_assert_output_jq finishers '. == {"Osprey":12.5,"Kestrel":13.1,"Tern":11.9}' \
  "finishers should be Osprey 12.5, Kestrel 13.1, Tern 11.9 (decimal comma and stray space handled, DNF/DSQ left out)"
tm_assert_output_jq no_time '. == ["Gull","Heron"]' "no_time should list the boats without a numeric time: Gull, Heron"
tm_assert_output winner Tern
tm_assert_output fastest_minutes 11.9
tm_assert_file_equals board/results.txt "Kestrel: 13.1 min
Osprey: 12.5 min
Tern: 11.9 min
Gull: no time
Heron: no time
"

tm_plan_json -var 'raw_times={Alpha="9,75",Bravo=" 10 ",Charlie="ret",Delta="9.7"}'
jq -e '.planned_values.outputs.finishers.value == {"Alpha":9.75,"Bravo":10,"Delta":9.7}
  and .planned_values.outputs.no_time.value == ["Charlie"]
  and .planned_values.outputs.winner.value == "Delta"
  and .planned_values.outputs.fastest_minutes.value == 9.7' "$TM_TMP/plan.json" >/dev/null \
  || tm_fail "for other raw times the finishers, no_time list and winner must be recomputed (9,75 means 9.75; 'ret' is not a time)"
tm_pass "messy time strings are normalized, non-numeric entries are set aside, and the winner is computed"
