#!/usr/bin/env bash
source "$TM_LIB"

LINEAGE=$(tm_recall lineage)
[[ -n "$LINEAGE" && -n "$(tm_recall bay)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'resource[[:space:]]+"random_integer"[[:space:]]+"quarantine_bay"' "the quarantine bay must stay in the configuration"
tm_assert_config_has 'keepers[[:space:]]*=[[:space:]]*toset\(\[[^]]*"cleo"' "the keeper list in main.tf must still include cleo"
tm_assert_config_has 'toset\(\[[^]]*"owls"' "the enclosure list must still include the owls"

STATE=$(terraform state pull 2>/dev/null)
[[ -n "$STATE" ]] || tm_fail "cannot read the current state"
[[ "$(jq -r .lineage <<<"$STATE")" == "$LINEAGE" ]] || tm_fail "the state belongs to a different project (lineage mismatch)"
[[ "$(jq -r .serial <<<"$STATE")" -gt 9 ]] || tm_fail "the state is still the overwritten stale copy"

for k in asha bram cleo; do
  tm_assert_in_state "random_id.keeper_badge[\"$k\"]" "keeper $k has no badge in state"
  [[ "$(tm_state_attr "random_id.keeper_badge[\"$k\"]" hex)" == "$(tm_recall "badge_$k")" ]] || tm_fail "badge of keeper $k is not the issued one"
done
for a in otters owls; do
  [[ "$(tm_state_attr "random_integer.enclosure_slot[\"$a\"]" result)" == "$(tm_recall "slot_$a")" ]] || tm_fail "the $a enclosure slot is not the registered one"
done
[[ "$(tm_state_attr random_uuid.rota_epoch result)" == "$(tm_recall epoch)" ]] || tm_fail "the rota epoch was regenerated"
[[ "$(tm_state_attr local_file.feeding_rota id)" == "$(tm_recall rota)" ]] || tm_fail "the feeding rota was rewritten"
[[ "$(tm_state_attr random_integer.quarantine_bay result)" == "$(tm_recall bay)" ]] || tm_fail "the quarantine bay is not the one CI run 217 assigned to the heron"
[[ "$(tm_state_count)" == "8" ]] || tm_fail "state should hold 8 objects, found $(tm_state_count)"

tm_assert_no_destroy
tm_assert_no_changes
tm_assert_output quarantine_bay "$(tm_recall bay)"
tm_pass "the right state copy is live, the lost bay assignment is adopted, nothing was re-issued"
