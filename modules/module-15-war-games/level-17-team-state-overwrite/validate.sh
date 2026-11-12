#!/usr/bin/env bash
source "$TM_LIB"

LINEAGE=$(tm_recall lineage)
[[ -n "$LINEAGE" && -n "$(tm_recall rack)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'resource[[:space:]]+"random_integer"[[:space:]]+"repair_rack"' "the repair rack must stay in the configuration"
tm_assert_config_has 'stewards[[:space:]]*=[[:space:]]*toset\(\[[^]]*"cleo"' "the steward list in main.tf must still include cleo"
tm_assert_config_has 'toset\(\[[^]]*"owls"' "the design list must still include the owls"

STATE=$(terraform state pull 2>/dev/null)
[[ -n "$STATE" ]] || tm_fail "cannot read the current state"
[[ "$(jq -r .lineage <<<"$STATE")" == "$LINEAGE" ]] || tm_fail "the state belongs to a different project (lineage mismatch)"
[[ "$(jq -r .serial <<<"$STATE")" -gt 9 ]] || tm_fail "the state is still the overwritten stale copy"

for k in asha bram cleo; do
  tm_assert_in_state "random_id.steward_badge[\"$k\"]" "steward $k has no badge in state"
  [[ "$(tm_state_attr "random_id.steward_badge[\"$k\"]" hex)" == "$(tm_recall "badge_$k")" ]] || tm_fail "badge of steward $k is not the issued one"
done
for a in otters owls; do
  [[ "$(tm_state_attr "random_integer.bench_slot[\"$a\"]" result)" == "$(tm_recall "slot_$a")" ]] || tm_fail "the $a bench slot is not the registered one"
done
[[ "$(tm_state_attr random_uuid.rota_epoch result)" == "$(tm_recall epoch)" ]] || tm_fail "the rota epoch was regenerated"
[[ "$(tm_state_attr local_file.build_rota id)" == "$(tm_recall rota)" ]] || tm_fail "the build rota was rewritten"
[[ "$(tm_state_attr random_integer.repair_rack result)" == "$(tm_recall rack)" ]] || tm_fail "the repair rack is not the one CI run 217 assigned to the heron"
[[ "$(tm_state_count)" == "8" ]] || tm_fail "state should hold 8 objects, found $(tm_state_count)"

tm_assert_no_destroy
tm_assert_no_changes
tm_assert_output repair_rack "$(tm_recall rack)"
tm_pass "the right state copy is live, the lost rack assignment is adopted, nothing was re-issued"
