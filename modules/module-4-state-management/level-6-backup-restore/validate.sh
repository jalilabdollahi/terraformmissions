#!/usr/bin/env bash
source "$TM_LIB"

PET=$(tm_recall pet); BAY=$(tm_recall bay); STOCK=$(tm_recall stock)
[[ -n "$PET" && -n "$BAY" && -n "$STOCK" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_pet" "sales_manager"' "the sales_manager resource was removed from the configuration"
tm_assert_config_has 'resource "random_string" "bay_code"' "the bay_code resource was removed from the configuration"
tm_assert_config_has 'resource "random_integer" "stock_number"' "the stock_number resource was removed from the configuration"

tm_assert_in_state random_pet.sales_manager "random_pet.sales_manager is still missing from state"
tm_assert_in_state random_string.bay_code "random_string.bay_code is still missing from state"
tm_assert_in_state random_integer.stock_number "random_integer.stock_number is still missing from state"
tm_assert_in_state local_file.stock_index "local_file.stock_index is missing from state"

[[ "$(tm_state_attr random_pet.sales_manager id)" == "$PET" ]] \
  || tm_fail "the sales manager is '$(tm_state_attr random_pet.sales_manager id)', not the original '$PET' — the old values were not restored"
[[ "$(tm_state_attr random_string.bay_code result)" == "$BAY" ]] || tm_fail "the bay code is not the original one"
[[ "$(tm_state_attr random_integer.stock_number result)" == "$STOCK" ]] || tm_fail "the stock number is not the original one"

tm_assert_no_changes
tm_assert_file_contains stock/index.txt "$PET" "stock/index.txt does not show the original sales manager"
tm_pass "the stock list state is back: manager '$PET', bay $BAY, stock no. $STOCK"
