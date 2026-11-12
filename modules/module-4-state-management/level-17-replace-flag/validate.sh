#!/usr/bin/env bash
source "$TM_LIB"

for e in main vip cloakroom dj; do
  [[ -n "$(tm_recall "code_$e")" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"
done

tm_assert_config_has 'resource "random_integer" "door_code"' "the door_code resource was removed from the configuration"
tm_assert_config_lacks 'keepers' "this mission is solved with a CLI option, not by adding keepers to the resource"
tm_assert_config_lacks 'replace_triggered_by' "this mission is solved with a CLI option, not a lifecycle trigger"

for e in main vip cloakroom dj; do
  tm_assert_in_state "random_integer.door_code[\"$e\"]" "the $e door code is missing from state"
done

NEW=$(tm_state_attr 'random_integer.door_code["dj"]' result)
[[ "$NEW" != "$(tm_recall code_dj)" ]] || tm_fail "the DJ code is still $NEW — the leaked code is still valid"

for e in main vip cloakroom; do
  CUR=$(tm_state_attr "random_integer.door_code[\"$e\"]" result)
  [[ "$CUR" == "$(tm_recall "code_$e")" ]] || tm_fail "the $e code changed ($(tm_recall "code_$e") → $CUR) — only the DJ code was to be regenerated"
done

tm_assert_no_changes
tm_assert_file_contains cards/staff.txt "dj: $NEW" "the printed staff card does not show the new dj code"
tm_pass "dj code rotated to $NEW; the other three codes are untouched"
