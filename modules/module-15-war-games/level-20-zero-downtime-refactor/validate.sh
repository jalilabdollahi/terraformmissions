#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall licence)" && -n "$(tm_recall rennet_brie)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'moved[[:space:]]*\{' "describe the address changes with moved blocks"
tm_assert_config_has 'removed[[:space:]]*\{' "the retired trial batch needs a removed block"
tm_assert_config_has 'destroy[[:space:]]*=[[:space:]]*false' "forgetting the trial batch must not destroy it"
tm_assert_config_has 'resource[[:space:]]+"terraform_data"[[:space:]]+"cip_cycle"' "the CIP cycle must live on as terraform_data.cip_cycle"
tm_assert_config_lacks 'resource[[:space:]]+"null_resource"' "null_resource is retired in the new tree"
tm_assert_config_lacks 'resource[[:space:]]+"random_integer"[[:space:]]+"trial_batch"' "the trial batch is no longer managed"
tm_assert_config_lacks '^[[:space:]]*count[[:space:]]*=' "no count indexes in the new tree"
for m in milkhouse caves compliance cultures; do
  tm_assert_config_has "module[[:space:]]+\"$m\"" "the module tree must keep the $m module"
done
tm_assert_config_has 'module[[:space:]]+"rooms"' "the rooms module must stay nested inside caves"

TM_MSG="the plan destroys or replaces dairy objects - some address change is not described" tm_assert_no_destroy
tm_apply

for k in curd whey cold1 cold2; do
  [[ "$(tm_state_attr "module.milkhouse.random_id.vat_serial[\"$k\"]" hex)" == "$(tm_recall "vat_$k")" ]] || tm_fail "vat $k lost its serial"
done
for k in r1 r2 r3; do
  [[ "$(tm_state_attr "module.caves.module.rooms.random_integer.shelves[\"$k\"]" result)" == "$(tm_recall "shelves_$k")" ]] \
    || tm_fail "room $k does not hold its own capacity - the old indexes were mapped to the wrong names"
done
[[ "$(tm_state_attr module.caves.terraform_data.cip_cycle id)" == "$(tm_recall cip)" ]] || tm_fail "the CIP cycle record was recreated"
[[ "$(tm_state_attr module.compliance.random_uuid.licence result)" == "$(tm_recall licence)" ]] || tm_fail "the dairy licence changed"
[[ "$(tm_state_attr module.compliance.time_static.first_churn rfc3339)" == "$(tm_recall first_churn)" ]] || tm_fail "the first-churn timestamp changed"
for k in bluemould brie; do
  [[ "$(tm_state_attr "module.cultures.random_integer.strain_grams[\"$k\"]" result)" == "$(tm_recall "rennet_$k")" ]] || tm_fail "rennet strain $k changed weight"
done
[[ "$(tm_state_attr local_file.dairy_sheet id)" == "$(tm_recall sheet_id)" ]] || tm_fail "the dairy sheet was rewritten"

STATE=$(tm_state_list)
grep -qE '^(random_id|random_integer|random_uuid|time_static|null_resource|terraform_data)\.|^module\.rennet' <<<"$STATE" && tm_fail "objects remain at their pre-refactor addresses in state"
tm_assert_not_in_state random_integer.trial_batch "the trial batch must be forgotten"
[[ "$(grep -c . <<<"$STATE")" == "13" ]] || tm_fail "state should hold 13 objects, found $(grep -c . <<<"$STATE")"
tm_assert_no_changes
tm_pass "module tree in place, 13 objects moved or forgotten with zero destroy and zero re-issue"
