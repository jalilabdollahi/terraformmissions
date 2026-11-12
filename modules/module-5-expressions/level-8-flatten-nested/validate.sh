#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'flatten[[:space:]]*\(' "the nested lists must be flattened with flatten()"
tm_assert_config_has 'for_each' "the stubs must still be created with for_each"

tm_apply
tm_assert_output bout_count 6
# (state list is captured first: grep -q on a live pipe can trip pipefail via SIGPIPE)
STATE=$(terraform state list 2>/dev/null)
for key in "Ring One/Mercer v Vance" "The Cage/Reyes v Quinn"; do
  grep -qxF -- "local_file.stub[\"$key\"]" <<<"$STATE" || tm_fail "there should be a stub keyed \"$key\""
done
[[ "$(grep -c . <<<"$STATE")" == "6" ]] || tm_fail "expected 6 ticket stubs in state, found $(grep -c . <<<"$STATE")"
tm_assert_file_equals stubs/the-cage-silva-v-novak.txt "Silva v Novak — The Cage
"
tm_assert_output_jq stub_files '. == ["ring-one-mercer-v-vance.txt","ring-one-okoro-v-lund.txt","ring-two-haas-v-diaz.txt","the-cage-kato-v-brandt.txt","the-cage-reyes-v-quinn.txt","the-cage-silva-v-novak.txt"]'

# A different programme must produce exactly one stub per bout.
tm_plan_json -var 'programme={"Gym Floor"=["Marsh v Cole","Pike v Dunn"],"Spare Ring"=[],"Annex"=["Ito v Park"]}'
planned=$(jq -r '[.resource_changes[]? | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
want='local_file.stub["Annex/Ito v Park"],local_file.stub["Gym Floor/Marsh v Cole"],local_file.stub["Gym Floor/Pike v Dunn"]'
[[ "$planned" == "$want" ]] || tm_fail "a programme with 3 bouts should plan exactly: $want (got: $planned)"
tm_pass "every bout in every ring becomes its own stub through flatten()"
