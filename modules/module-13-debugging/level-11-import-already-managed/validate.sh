#!/usr/bin/env bash
source "$TM_LIB"

CODE=$(tm_recall code)
[[ -n "$CODE" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'resource[[:space:]]+"random_integer"[[:space:]]+"cabinet_code"' "random_integer.cabinet_code must stay in the configuration"
tm_assert_config_lacks 'cabinet_dup' "the duplicate is not meant to come back into the configuration"
tm_assert_config_lacks 'import[[:space:]]*\{' "importing again is how the duplicate was created"

tm_assert_in_state random_integer.cabinet_code "random_integer.cabinet_code vanished from state"
tm_assert_not_in_state random_integer.cabinet_dup "random_integer.cabinet_dup is still in state"
[[ "$(tm_state_attr random_integer.cabinet_code result)" == "$CODE" ]] \
  || tm_fail "the cabinet code changed - the registered cabinet must keep code $CODE"
COUNT=$(terraform show -json | jq '[.values.root_module.resources[]? | select(.type == "random_integer")] | length')
[[ "$COUNT" == "1" ]] || tm_fail "state holds $COUNT random_integer objects, expected exactly one"

tm_assert_no_destroy
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output cabinet_code "$CODE"
tm_assert_file_equals ledger/floor.txt "Cabinet code on the floor: $CODE"$'\n' "the floor ledger changed"
tm_pass "one registration remains for cabinet $CODE and nothing was destroyed"
