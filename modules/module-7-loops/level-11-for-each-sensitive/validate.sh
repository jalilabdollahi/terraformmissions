#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'sensitive[[:space:]]*=[[:space:]]*true' "var.pins must stay sensitive - the PINs are secrets"
tm_assert_config_lacks 'nonsensitive\([[:space:]]*var\.pins' "do not strip the sensitivity of the PIN map itself - only the operator names are public"
tm_assert_config_has 'var\.pins\[each\.(key|value)\]|var\.pins\[' "each slip must still read its PIN from var.pins"
tm_apply
tm_assert_output slip_count "3"
for pair in vesna:4417 hamid:9082 lotte:5530; do
  n=${pair%%:*}; p=${pair#*:}
  tm_assert_in_state "local_sensitive_file.pin_slip[\"$n\"]" "no slip keyed by \"$n\""
  [[ "$(cat "slips/$n.pin" 2>/dev/null)" == "$p" ]] || tm_fail "slips/$n.pin should contain exactly $n's PIN"
done
tm_plan_json -var 'pins={zed="1111",amel="2222"}'
adds=$(jq -r '[.resource_changes[] | select(.change.actions == ["create"]) | .address] | sort | join(",")' "$TM_TMP/plan.json")
[[ "$adds" == 'local_sensitive_file.pin_slip["amel"],local_sensitive_file.pin_slip["zed"]' ]] \
  || tm_fail "slips should follow the names in var.pins; plan creates: ${adds:-nothing}"
if grep -qE '1111|2222|4417' "$TM_LAST_OUT"; then tm_fail "a PIN leaked into the plan output"; fi
tm_pass "slips are keyed by operator name, PINs remain secret"
