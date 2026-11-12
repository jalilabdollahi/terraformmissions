#!/usr/bin/env bash
source "$TM_LIB"

PET=$(tm_recall pet); AISLE=$(tm_recall aisle); LOT=$(tm_recall lot)
[[ -n "$PET" && -n "$AISLE" && -n "$LOT" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "store_manager"' "the store_manager resource was removed from the configuration"
tm_assert_config_has 'resource "random_string" "aisle_code"' "the aisle_code resource was removed from the configuration"
tm_assert_config_has 'resource "random_integer" "lot_number"' "the lot_number resource was removed from the configuration"

tm_assert_in_state random_pet.store_manager "random_pet.store_manager is still missing from state"
tm_assert_in_state random_string.aisle_code "random_string.aisle_code is still missing from state"
tm_assert_in_state random_integer.lot_number "random_integer.lot_number is still missing from state"
tm_assert_in_state local_file.inventory_index "local_file.inventory_index is missing from state"

[[ "$(tm_state_attr random_pet.store_manager id)" == "$PET" ]] \
  || tm_fail "the store manager is '$(tm_state_attr random_pet.store_manager id)', not the original '$PET' — the old values were not restored"
[[ "$(tm_state_attr random_string.aisle_code result)" == "$AISLE" ]] || tm_fail "the aisle code is not the original one"
[[ "$(tm_state_attr random_integer.lot_number result)" == "$LOT" ]] || tm_fail "the lot number is not the original one"

tm_assert_no_changes
tm_assert_file_contains inventory/index.txt "$PET" "inventory/index.txt does not show the original store manager"
tm_pass "the inventory list state is back: manager '$PET', aisle $AISLE, lot no. $LOT"
