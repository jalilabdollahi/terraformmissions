#!/usr/bin/env bash
source "$TM_LIB"

CODE=$(tm_recall code)
[[ -n "$CODE" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'resource[[:space:]]+"random_integer"[[:space:]]+"service_code"' "random_integer.service_code must stay in the configuration"
tm_assert_config_lacks 'service_dup' "the duplicate is not meant to come back into the configuration"
tm_assert_config_lacks 'import[[:space:]]*\{' "importing again is how the duplicate was created"

tm_assert_in_state random_integer.service_code "random_integer.service_code vanished from state"
tm_assert_not_in_state random_integer.service_dup "random_integer.service_dup is still in state"
[[ "$(tm_state_attr random_integer.service_code result)" == "$CODE" ]] \
  || tm_fail "the service code changed - the registered telephone box must keep code $CODE"
COUNT=$(terraform show -json | jq '[.values.root_module.resources[]? | select(.type == "random_integer")] | length')
[[ "$COUNT" == "1" ]] || tm_fail "state holds $COUNT random_integer objects, expected exactly one"

tm_assert_no_destroy
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output service_code "$CODE"
tm_assert_file_equals ledger/kiosk.txt "Service code on the kiosk: $CODE"$'\n' "the kiosk ledger changed"
tm_pass "one registration remains for telephone box $CODE and nothing was destroyed"
