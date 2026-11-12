#!/usr/bin/env bash
source "$TM_LIB"
for s in odette odile benno; do
  [[ -n "$(tm_recall "pet_$s")" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"
done
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*toset\(var\.pedalos\)' "the resource should keep using for_each"
moves=$(grep -rhE --include='*.tf' 'moved[[:space:]]*\{' . | wc -l | tr -d ' ')
[[ "$moves" -ge 3 ]] || tm_fail "expected one moved block per pedalo (3), found $moves"
# the plan must keep every existing mascot: no destroy, no replace
TM_MSG="plan would destroy or replace a mascot - the hulls are already painted" tm_assert_no_destroy
tm_apply
for s in odette odile benno; do
  tm_assert_in_state "random_pet.mascot[\"$s\"]" "random_pet.mascot[\"$s\"] is not in state"
  now=$(tm_state_attr "random_pet.mascot[\"$s\"]" id)
  [[ "$now" == "$(tm_recall "pet_$s")" ]] || tm_fail "the mascot for $s changed: '$(tm_recall "pet_$s")' became '$now' - it landed on the wrong key or was recreated"
done
for i in 0 1 2; do
  tm_assert_not_in_state "random_pet.mascot[$i]" "random_pet.mascot[$i] is still in state under the numeric index"
done
tm_assert_no_changes
tm_assert_file_contains roster.txt "odile: $(tm_recall pet_odile)"
# a new pedalo is the only thing that gets created
tm_plan_json -var 'pedalos=["odette","odile","benno","rothbart"]'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'random_pet.mascot["rothbart"]' ]] || tm_fail "a new pedalo should add exactly one mascot; plan creates: ${adds:-nothing}"
tm_pass "all three mascots kept their names and now live at string keys"
