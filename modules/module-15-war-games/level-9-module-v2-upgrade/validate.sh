#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall pet_alma)" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'ignore_changes' "lifecycle tricks are not an upgrade path"
tm_assert_config_has 'v2|callsign' "the v2 module must stay in use"
tm_validate

for n in alma brecon cullen dara emlyn; do
  tm_assert_in_state "module.roster.random_pet.callsign[\"$n\"]" "call-sign for $n is not at the v2 address"
  tm_assert_in_state "module.roster.local_file.duty_card[\"$n\"]" "duty card for $n is not at the v2 address"
  tm_assert_not_in_state "module.roster.random_pet.member[\"$n\"]" "old-address call-sign for $n is still in state"
  [[ "$(tm_state_attr "module.roster.random_pet.callsign[\"$n\"]" id)" == "$(tm_recall "pet_$n")" ]] \
    || tm_fail "call-sign for $n changed - it is painted on a helmet"
done

tm_assert_no_destroy
TM_MSG="plan is not clean after the upgrade" tm_assert_no_changes

for n in alma brecon cullen dara emlyn; do
  tm_assert_file_contains "cards/$n.txt" "$(tm_recall "pet_$n")"
  tm_assert_file_contains "cards/$n.txt" "shift 12h" "card for $n changed its shift length - the welfare policy is not in force yet"
done
tm_assert_output_jq crew_callsigns 'length == 5' "crew_callsigns output is wrong"
tm_pass "v2 module adopted in place: ten objects kept, shift length unchanged, plan clean"
