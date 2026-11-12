#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall licence)" && -n "$(tm_recall paint_crimson)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'moved[[:space:]]*\{' "describe the address changes with moved blocks"
tm_assert_config_has 'removed[[:space:]]*\{' "the retired prototype run needs a removed block"
tm_assert_config_has 'destroy[[:space:]]*=[[:space:]]*false' "forgetting the prototype run must not destroy it"
tm_assert_config_has 'resource[[:space:]]+"terraform_data"[[:space:]]+"oil_cycle"' "the oiling cycle must live on as terraform_data.oil_cycle"
tm_assert_config_lacks 'resource[[:space:]]+"null_resource"' "null_resource is retired in the new tree"
tm_assert_config_lacks 'resource[[:space:]]+"random_integer"[[:space:]]+"prototype_run"' "the prototype run is no longer managed"
tm_assert_config_lacks '^[[:space:]]*count[[:space:]]*=' "no count indexes in the new tree"
for m in movements stables compliance finishes; do
  tm_assert_config_has "module[[:space:]]+\"$m\"" "the module tree must keep the $m module"
done
tm_assert_config_has 'module[[:space:]]+"stalls"' "the stalls module must stay nested inside stables"

TM_MSG="the plan destroys or replaces works objects - some address change is not described" tm_assert_no_destroy
tm_apply

for k in brass steel coil1 coil2; do
  [[ "$(tm_state_attr "module.movements.random_id.spring_serial[\"$k\"]" hex)" == "$(tm_recall "spring_$k")" ]] || tm_fail "spring $k lost its serial"
done
for k in h1 h2 h3; do
  [[ "$(tm_state_attr "module.stables.module.stalls.random_integer.loads[\"$k\"]" result)" == "$(tm_recall "loads_$k")" ]] \
    || tm_fail "stall $k does not hold its own load rating - the old indexes were mapped to the wrong names"
done
[[ "$(tm_state_attr module.stables.terraform_data.oil_cycle id)" == "$(tm_recall oil)" ]] || tm_fail "the oiling cycle record was recreated"
[[ "$(tm_state_attr module.compliance.random_uuid.licence result)" == "$(tm_recall licence)" ]] || tm_fail "the ride licence changed"
[[ "$(tm_state_attr module.compliance.time_static.first_spin rfc3339)" == "$(tm_recall first_spin)" ]] || tm_fail "the first-spin timestamp changed"
for k in gold crimson; do
  [[ "$(tm_state_attr "module.finishes.random_integer.coat_grams[\"$k\"]" result)" == "$(tm_recall "paint_$k")" ]] || tm_fail "paint coat $k changed weight"
done
[[ "$(tm_state_attr local_file.works_sheet id)" == "$(tm_recall sheet_id)" ]] || tm_fail "the works sheet was rewritten"

STATE=$(tm_state_list)
grep -qE '^(random_id|random_integer|random_uuid|time_static|null_resource|terraform_data)\.|^module\.paint' <<<"$STATE" && tm_fail "objects remain at their pre-refactor addresses in state"
tm_assert_not_in_state random_integer.prototype_run "the prototype run must be forgotten"
[[ "$(grep -c . <<<"$STATE")" == "13" ]] || tm_fail "state should hold 13 objects, found $(grep -c . <<<"$STATE")"
tm_assert_no_changes
tm_pass "module tree in place, 13 objects moved or forgotten with zero destroy and zero re-issue"
