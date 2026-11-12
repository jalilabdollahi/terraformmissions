#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_pet" "table"' "random_pet.table must stay"
tm_assert_config_has 'resource "random_integer" "seat"' "random_integer.seat must stay"
tm_apply
TABLE=$(tm_state_attr random_pet.table id)
SEAT=$(tm_state_attr random_integer.seat result)
[[ -n "$TABLE" && -n "$SEAT" ]] || tm_fail "the random resources are not in state"
tm_assert_file_equals hoststand/slip.txt "Your table: $TABLE, seat $SEAT
"
tm_assert_output table_name "$TABLE"
tm_assert_output seat_number "$SEAT"
tm_assert_no_changes
tm_pass "slip shows $TABLE, seat $SEAT"
