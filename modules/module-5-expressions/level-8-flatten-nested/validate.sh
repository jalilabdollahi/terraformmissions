#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'flatten[[:space:]]*\(' "the nested lists must be flattened with flatten()"
tm_assert_config_has 'for_each' "the stubs must still be created with for_each"

tm_apply
tm_assert_output showing_count 6
# (state list is captured first: grep -q on a live pipe can trip pipefail via SIGPIPE)
STATE=$(terraform state list 2>/dev/null)
for key in "Screen One/Metropolis" "The Vault/Ran"; do
  grep -qxF -- "local_file.stub[\"$key\"]" <<<"$STATE" || tm_fail "there should be a stub keyed \"$key\""
done
[[ "$(grep -c . <<<"$STATE")" == "6" ]] || tm_fail "expected 6 ticket stubs in state, found $(grep -c . <<<"$STATE")"
tm_assert_file_equals stubs/the-vault-rear-window.txt "Rear Window — The Vault
"
tm_assert_output_jq stub_files '. == ["screen-one-metropolis.txt","screen-one-vertigo.txt","screen-two-stalker.txt","the-vault-persona.txt","the-vault-ran.txt","the-vault-rear-window.txt"]'

# A different programme must produce exactly one stub per showing.
tm_plan_json -var 'programme={"Rooftop"=["Alien","Heat"],"Bar"=[],"Annex"=["Jaws"]}'
planned=$(jq -r '[.resource_changes[]? | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
want='local_file.stub["Annex/Jaws"],local_file.stub["Rooftop/Alien"],local_file.stub["Rooftop/Heat"]'
[[ "$planned" == "$want" ]] || tm_fail "a programme with 3 showings should plan exactly: $want (got: $planned)"
tm_pass "every showing in every screen becomes its own stub through flatten()"
