#!/usr/bin/env bash
source "$TM_LIB"

for e in stage pit box-office booth; do
  [[ -n "$(tm_recall "code_$e")" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"
done

tm_assert_config_has 'resource "random_integer" "door_code"' "the door_code resource was removed from the configuration"
tm_assert_config_lacks 'keepers' "this mission is solved with a CLI option, not by adding keepers to the resource"
tm_assert_config_lacks 'replace_triggered_by' "this mission is solved with a CLI option, not a lifecycle trigger"

for e in stage pit box-office booth; do
  tm_assert_in_state "random_integer.door_code[\"$e\"]" "the $e door code is missing from state"
done

NEW=$(tm_state_attr 'random_integer.door_code["booth"]' result)
[[ "$NEW" != "$(tm_recall code_booth)" ]] || tm_fail "the booth code is still $NEW — the leaked code is still valid"

for e in stage pit box-office; do
  CUR=$(tm_state_attr "random_integer.door_code[\"$e\"]" result)
  [[ "$CUR" == "$(tm_recall "code_$e")" ]] || tm_fail "the $e code changed ($(tm_recall "code_$e") → $CUR) — only the booth code was to be regenerated"
done

tm_assert_no_changes
tm_assert_file_contains cards/crew.txt "booth: $NEW" "the printed crew card does not show the new booth code"
tm_pass "booth code rotated to $NEW; the other three codes are untouched"
