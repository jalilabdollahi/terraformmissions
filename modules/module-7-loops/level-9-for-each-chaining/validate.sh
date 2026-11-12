#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*random_pet\.callsign[[:space:]]*$' \
  "the wing cards should be created by chaining for_each onto random_pet.callsign"
tm_apply
for c in amira bram chidi; do
  tm_assert_in_state "random_pet.callsign[\"$c\"]" "random_pet.callsign[\"$c\"] missing"
  tm_assert_in_state "local_file.wing_card[\"$c\"]" "local_file.wing_card[\"$c\"] missing"
  sign=$(tm_state_attr "random_pet.callsign[\"$c\"]" id)
  [[ "$sign" == sky-* ]] || tm_fail "call sign for $c looks wrong: '$sign'"
  tm_assert_file_equals "wings/$c.txt" "Cadet wing card - $c: call sign $sign
" "wings/$c.txt must carry $c's own call sign ($sign)"
done
tm_assert_no_changes
# a new cadet gets both a call sign and a card; a leaver loses both; nobody else is touched
tm_plan_json -var 'cadets=["amira","chidi","dara"]'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'local_file.wing_card["dara"],random_pet.callsign["dara"]' ]] \
  || tm_fail "a new cadet should add one call sign and one card; plan creates: ${adds:-nothing}"
dels=$(tm_plan_deletes | sort | tr '\n' ',')
[[ "$dels" == 'local_file.wing_card["bram"],random_pet.callsign["bram"],' ]] \
  || tm_fail "removing bram should remove only his call sign and card; plan deletes: ${dels:-nothing}"
tm_pass "wing cards are chained to the call signs: one per cadet, keyed by name"
