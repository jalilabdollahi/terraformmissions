#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall network_key)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"
tm_assert_file register/gauges.json "register/gauges.json must stay in the workspace"

tm_assert_config_has 'import[[:space:]]*\{' "the gauges must be adopted with import blocks"
tm_assert_config_has 'for_each[[:space:]]*=[[:space:]]*local\.[A-Za-z_]+' "the import block should loop over the register with for_each, not one block per gauge"
# No serial may be pasted into the code: they have to come from the register.
for s in $(jq -r '.stations[].serial' register/gauges.json); do
  tm_assert_config_lacks "$s" "a gauge serial is typed into the configuration - read the register instead"
done

# Expected adoption set computed from the register itself.
ACTIVE=$(jq -r '.stations[] | select(.status=="active") | .station' register/gauges.json)
RETIRED=$(jq -r '.stations[] | select(.status!="active") | .station' register/gauges.json)
[[ "$(grep -c . <<<"$ACTIVE")" == "15" ]] || tm_fail "register/gauges.json was changed: it must keep 15 active stations"

TM_MSG="plan would destroy or replace a gauge (byte length or serial mismatch)" tm_assert_no_destroy
if jq -e '[.resource_changes[]? | select(.type=="random_id" and (.address|startswith("random_id.gauge")) and (.change.actions|index("create")))] | length > 0' "$TM_TMP/plan.json" >/dev/null; then
  tm_fail "the plan still creates brand-new gauges instead of adopting the existing ones"
fi
tm_apply

for st in $ACTIVE; do
  addr="random_id.gauge[\"$st\"]"
  tm_assert_in_state "$addr" "gauge $st is not managed"
  serial=$(jq -r --arg s "$st" '.stations[] | select(.station==$s) | .serial' register/gauges.json)
  [[ "$(tm_state_attr "$addr" id)" == "$serial" ]] || tm_fail "gauge $st does not carry the serial from the register"
  want=$(python3 - "$serial" <<'PY'
import base64, sys
s = sys.argv[1]
print(base64.urlsafe_b64decode(s + "=" * (-len(s) % 4)).hex())
PY
)
  [[ "$(tm_state_attr "$addr" hex)" == "$want" ]] || tm_fail "gauge $st hex does not match its serial"
  tm_assert_file_contains out/gauge-roster.txt "gauge $st $want" "the roster has no line for gauge $st"
done
for st in $RETIRED; do
  tm_assert_not_in_state "random_id.gauge[\"$st\"]" "retired gauge $st must not be adopted"
done
[[ "$(tm_state_attr random_id.network_key hex)" == "$(tm_recall network_key)" ]] || tm_fail "the network key changed"
tm_assert_output gauge_count 15
tm_assert_in_state local_file.gauge_roster "the roster file is not managed"
tm_assert_no_changes
tm_pass "15 active gauges adopted with their registered serials, retired ones left alone, network key intact"
