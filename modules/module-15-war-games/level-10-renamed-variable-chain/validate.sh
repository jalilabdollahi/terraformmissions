#!/usr/bin/env bash
source "$TM_LIB"

BEACON=$(tm_recall beacon); CHAN=$(tm_recall channel)
[[ -n "$BEACON" && -n "$CHAN" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'station_callsign|base_callsign' "an old variable name is still referenced somewhere in the chain (including tfvars)"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks hide the replacement instead of preventing it"
tm_assert_config_has 'MR-ALPINE-7' "the station's radio identity MR-ALPINE-7 must be supplied through the variable chain"

tm_validate

[[ "$(tm_state_attr module.region.module.post.random_id.beacon id)" == "$BEACON" ]] \
  || tm_fail "the beacon serial was regenerated - the field radios are programmed with the old one"
[[ "$(tm_state_attr module.region.random_integer.channel result)" == "$CHAN" ]] \
  || tm_fail "the repeater channel was re-drawn - field radios are tuned to the old one"

tm_assert_no_destroy
TM_MSG="plan is not clean after the rename" tm_assert_no_changes

tm_assert_output channel "$CHAN"
tm_assert_output beacon_serial "$(printf '%s' "$BEACON" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')"
tm_assert_file stations/mr-alpine-7.txt "the station sheet moved - the identity did not reach the post module"
tm_assert_no_file stations/unset.txt "a sheet for the placeholder identity UNSET was written"
tm_assert_file_contains plan/dispatch.txt "station MR-ALPINE-7 channel $CHAN" "dispatch log does not show the station identity"
tm_pass "all three layers carry the new variable names and the identity value; nothing was regenerated"
