#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall licence)" && -n "$(tm_recall gate_in-3)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_lacks '^[[:space:]]*count[[:space:]]*=' "the refactor away from count must stay in place"
tm_assert_config_has 'for_each' "the hub register must keep using for_each"
MOVES=$(grep -rhE '^[[:space:]]*moved[[:space:]]*\{' --include='*.tf' --exclude-dir=.terraform . | wc -l | tr -d ' ')
[[ "$MOVES" -ge 20 ]] || tm_fail "found $MOVES moved blocks - the refactor changed 20 addresses and each one must be declared in code"

TM_MSG="the plan would destroy or replace hub objects - some address change is not mapped" tm_assert_no_destroy
tm_apply

for n in LD-1 LD-2 LD-3 LD-4 LD-5 LD-6; do
  [[ "$(tm_state_attr "random_id.loader[\"$n\"]" hex)" == "$(tm_recall "loader_$n")" ]] \
    || tm_fail "loader $n does not carry its original serial"
done
for n in A1 B2 C3 D4 E5 F6 G7; do
  [[ "$(tm_state_attr "random_integer.stand[\"$n\"]" result)" == "$(tm_recall "stand_$n")" ]] \
    || tm_fail "ramp stand $n holds another block's number - the old list order was mapped wrongly"
done
for n in in-1 in-2 in-3 out-1 out-2; do
  [[ "$(tm_state_attr "terraform_data.dock[\"$n\"]" id)" == "$(tm_recall "gate_$n")" ]] \
    || tm_fail "dock door $n lost its original identity"
done
[[ "$(tm_state_attr random_uuid.hub_licence result)" == "$(tm_recall licence)" ]] || tm_fail "the hub licence was regenerated"
[[ "$(tm_state_attr time_static.opening rfc3339)" == "$(tm_recall opening)" ]] || tm_fail "the opening timestamp changed"
[[ "$(tm_state_attr local_file.ramp_manifest id)" == "$(tm_recall manifest_id)" ]] || tm_fail "the ramp manifest was rewritten"

STATE=$(tm_state_list)
grep -qE 'loader_serial|stand_slot|dock_door|ops_licence|go_live' <<<"$STATE" && tm_fail "state still holds objects under pre-refactor addresses"
[[ "$(grep -c . <<<"$STATE")" == "21" ]] || tm_fail "state should hold exactly 21 objects, found $(grep -c . <<<"$STATE")"

tm_assert_no_changes
tm_pass "all 20 addresses moved by declaration, every loader, block and door kept its identity"
