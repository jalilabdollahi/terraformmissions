#!/usr/bin/env bash
source "$TM_LIB"

LINEAGE=$(tm_recall lineage)
[[ -n "$LINEAGE" && -n "$(tm_recall broken_serial)" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_lacks '^[[:space:]]*count[[:space:]]*=' "the configuration is not the problem - it must keep using for_each keys"
tm_assert_config_has 'module[[:space:]]+"station"' "the station module call must stay"
tm_assert_config_lacks '3\.7|>=[[:space:]]*4' "do not loosen provider versions: the pre-release build is not available"

[[ -f terraform.tfstate ]] || tm_fail "terraform.tfstate is missing"
jq -e . terraform.tfstate >/dev/null 2>&1 || tm_fail "terraform.tfstate is not valid JSON any more"
terraform state list >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "Terraform still cannot read the state"; }

STATE=$(jq -c . terraform.tfstate)
[[ "$(jq -r .lineage <<<"$STATE")" == "$LINEAGE" ]] || tm_fail "the state lineage changed: this is no longer the same state history"
[[ "$(jq -r .serial <<<"$STATE")" -gt "$(tm_recall broken_serial)" ]] || tm_fail "the state serial was not increased: a hand edit has to be a new revision of the state"
BAD=$(jq '[.resources[] | select(.type=="random_id" or .type=="random_integer") | .instances[] | select(.schema_version != 0)] | length' <<<"$STATE")
[[ "$BAD" == "0" ]] || tm_fail "$BAD instances still claim a schema version the installed provider does not know"

for k in alpine birch cedar dale; do
  tm_assert_in_state "random_id.cabin_tag[\"$k\"]" "cabin $k is not tracked under its name"
  [[ "$(tm_state_attr "random_id.cabin_tag[\"$k\"]" hex)" == "$(tm_recall "tag_$k")" ]] || tm_fail "cabin $k carries another cabin's tag - the keys were assigned in the wrong order"
done
for k in base top; do
  tm_assert_in_state "module.station.random_integer.load_limit[\"$k\"]" "station $k is not tracked under its name"
  [[ "$(tm_state_attr "module.station.random_integer.load_limit[\"$k\"]" result)" == "$(tm_recall "limit_$k")" ]] || tm_fail "the $k station limit is not the certified one"
done
[[ "$(tm_state_attr local_file.inspection_log id)" == "$(tm_recall log_id)" ]] || tm_fail "the inspection log was rewritten"
STATE_LIST=$(tm_state_list)
grep -qE '\[[0-9]+\]' <<<"$STATE_LIST" && tm_fail "some instances are still addressed by position"
[[ "$(grep -c . <<<"$STATE_LIST")" == "7" ]] || tm_fail "state should hold 7 objects, found $(grep -c . <<<"$STATE_LIST")"
tm_assert_no_destroy
tm_assert_no_changes
tm_pass "state readable again, every cabin and station limit keyed by name with its certified value"
