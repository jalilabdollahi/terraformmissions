#!/usr/bin/env bash
source "$TM_LIB"

PET=$(tm_recall pet); SHELF=$(tm_recall shelf); CARD=$(tm_recall card)
[[ -n "$PET" && -n "$SHELF" && -n "$CARD" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "head_librarian"' "the head_librarian resource was removed from the configuration"
tm_assert_config_has 'resource "random_string" "shelf_code"' "the shelf_code resource was removed from the configuration"
tm_assert_config_has 'resource "random_integer" "card_number"' "the card_number resource was removed from the configuration"

tm_assert_in_state random_pet.head_librarian "random_pet.head_librarian is still missing from state"
tm_assert_in_state random_string.shelf_code "random_string.shelf_code is still missing from state"
tm_assert_in_state random_integer.card_number "random_integer.card_number is still missing from state"
tm_assert_in_state local_file.catalog_index "local_file.catalog_index is missing from state"

[[ "$(tm_state_attr random_pet.head_librarian id)" == "$PET" ]] \
  || tm_fail "the head librarian is '$(tm_state_attr random_pet.head_librarian id)', not the original '$PET' — the old values were not restored"
[[ "$(tm_state_attr random_string.shelf_code result)" == "$SHELF" ]] || tm_fail "the shelf code is not the original one"
[[ "$(tm_state_attr random_integer.card_number result)" == "$CARD" ]] || tm_fail "the card number is not the original one"

tm_assert_no_changes
tm_assert_file_contains catalog/index.txt "$PET" "catalog/index.txt does not show the original head librarian"
tm_pass "the catalog state is back: librarian '$PET', shelf $SHELF, card $CARD"
