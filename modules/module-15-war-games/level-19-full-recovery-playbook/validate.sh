#!/usr/bin/env bash
source "$TM_LIB"

LINEAGE=$(tm_recall lineage)
[[ -n "$LINEAGE" && -n "$(tm_recall fuel)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'module[[:space:]]+"power"' "the power module call must stay"
tm_assert_config_has 'module[[:space:]]+"comms"' "the comms module call must stay"
tm_assert_config_has 'provisioner[[:space:]]+"local-exec"' "the dailies provisioner must stay"
tm_assert_config_lacks "$(tm_recall generator)" "an ID is typed into the configuration"
tm_assert_config_lacks 'ignore_changes' "drift must be repaired, not ignored"

jq -e . terraform.tfstate >/dev/null 2>&1 || tm_fail "terraform.tfstate is still not valid JSON"
STATE=$(terraform state pull 2>/dev/null)
[[ -n "$STATE" ]] || tm_fail "Terraform cannot read the state"
[[ "$(jq -r .lineage <<<"$STATE")" == "$LINEAGE" ]] || tm_fail "the state is not this stack's history (lineage mismatch)"

terraform validate -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "the configuration still does not validate"; }

# Identities that must have survived the whole incident.
[[ "$(tm_state_attr module.power.random_id.generator_serial hex)" == "$(tm_recall generator)" ]] || tm_fail "the generator serial changed"
[[ "$(tm_state_attr module.power.random_integer.fuel_litres result)" == "$(tm_recall fuel)" ]] || tm_fail "the fuel litres changed or were never recovered"
[[ "$(tm_state_attr module.comms.random_id.radio_key hex)" == "$(tm_recall radio)" ]] || tm_fail "the radio key was rotated: it is stamped on the unit radios"
[[ "$(tm_state_attr module.comms.random_integer.channel result)" == "$(tm_recall channel)" ]] || tm_fail "the radio channel changed"
[[ "$(tm_state_attr local_file.base_manifest id)" == "$(tm_recall manifest_id)" ]] || tm_fail "the base manifest was rewritten"

TAINTED=$(jq -r '[.resources[] | select(.instances[]?.status == "tainted") | "\(.module // "").\(.type).\(.name)"] | join(",")' <<<"$STATE")
[[ -z "$TAINTED" ]] || tm_fail "objects are still tainted: $TAINTED"
[[ "$(tm_state_attr terraform_data.dailies id)" != "$(tm_recall dailies_id)" ]] || tm_fail "the dailies was never re-run: it is the one from the failed attempt"
tm_assert_file_equals out/dailies.txt "dailies OK for $(tm_recall generator)"$'\n' "out/dailies.txt does not show a successful dailies run"
tm_assert_file_equals out/comms-sheet.txt "$(tm_recall sheet)"$'\n' "out/comms-sheet.txt still carries the manual edit"
tm_assert_file_contains out/base-manifest.txt "fuel $(tm_recall fuel)"
tm_assert_output fuel_litres "$(tm_recall fuel)"
tm_assert_no_changes
tm_pass "state restored, fuel tank re-adopted, radio key untouched, dailies redone, drift repaired, plan clean"
