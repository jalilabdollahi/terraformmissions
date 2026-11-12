#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall network_key)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"
tm_assert_file register/cabinets.json "register/cabinets.json must stay in the workspace"

tm_assert_config_has 'import[[:space:]]*\{' "the cabinets must be adopted with import blocks"
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*local\.[A-Za-z_]+' "the import block should loop over the register with for_each, not one block per cabinet"
# No serial may be pasted into the code: they have to come from the register.
for s in $(jq -r '.sites[].serial' register/cabinets.json); do
  tm_assert_config_lacks "$s" "a cabinet serial is typed into the configuration - read the register instead"
done

# Expected adoption set computed from the register itself.
ACTIVE=$(jq -r '.sites[] | select(.status=="active") | .site' register/cabinets.json)
RETIRED=$(jq -r '.sites[] | select(.status!="active") | .site' register/cabinets.json)
[[ "$(grep -c . <<<"$ACTIVE")" == "15" ]] || tm_fail "register/cabinets.json was changed: it must keep 15 active sites"

TM_MSG="plan would destroy or replace a cabinet (byte length or serial mismatch)" tm_assert_no_destroy
if jq -e '[.resource_changes[]? | select(.type=="random_id" and (.address|startswith("random_id.cabinet")) and (.change.actions|index("create")))] | length > 0' "$TM_TMP/plan.json" >/dev/null; then
  tm_fail "the plan still creates brand-new cabinets instead of adopting the existing ones"
fi
tm_apply

for st in $ACTIVE; do
  addr="random_id.cabinet[\"$st\"]"
  tm_assert_in_state "$addr" "cabinet $st is not managed"
  serial=$(jq -r --arg s "$st" '.sites[] | select(.site==$s) | .serial' register/cabinets.json)
  [[ "$(tm_state_attr "$addr" id)" == "$serial" ]] || tm_fail "cabinet $st does not carry the serial from the register"
  want=$(python3 - "$serial" <<'PY'
import base64, sys
s = sys.argv[1]
print(base64.urlsafe_b64decode(s + "=" * (-len(s) % 4)).hex())
PY
)
  [[ "$(tm_state_attr "$addr" hex)" == "$want" ]] || tm_fail "cabinet $st hex does not match its serial"
  tm_assert_file_contains out/cabinet-roster.txt "cabinet $st $want" "the roster has no line for cabinet $st"
done
for st in $RETIRED; do
  tm_assert_not_in_state "random_id.cabinet[\"$st\"]" "retired cabinet $st must not be adopted"
done
[[ "$(tm_state_attr random_id.network_key hex)" == "$(tm_recall network_key)" ]] || tm_fail "the network key changed"
tm_assert_output cabinet_count 15
tm_assert_in_state local_file.cabinet_roster "the roster file is not managed"
tm_assert_no_changes
tm_pass "15 active cabinets adopted with their registered serials, retired ones left alone, network key intact"
