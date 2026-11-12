#!/usr/bin/env bash
source "$TM_LIB"

ORIGINAL=$(tm_recall codename)
[[ -n "$ORIGINAL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "night_keeper"' \
  "the resource must keep its new name random_pet.night_keeper"
tm_assert_config_lacks 'moved[[:space:]]*\{' \
  "this mission is about moving the object in STATE with the CLI — no moved block"

tm_assert_not_in_state random_pet.keeper "random_pet.keeper is still in state"
tm_assert_in_state random_pet.night_keeper "random_pet.night_keeper is not in state"

CURRENT=$(tm_state_attr random_pet.night_keeper id)
[[ "$CURRENT" == "$ORIGINAL" ]] \
  || tm_fail "the keeper codename changed ('$ORIGINAL' → '$CURRENT') — the badge printers are furious"

tm_assert_no_changes
tm_assert_file_contains roster/night-shift.txt "$ORIGINAL" "roster/night-shift.txt doesn't show the keeper's codename"
tm_pass "random_pet.night_keeper still holds codename '$ORIGINAL' and the plan is clean"
