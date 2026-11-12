#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'first_ticket[[:space:]]*=[[:space:]]*1000' "the ticket range is fixed by the committee: first_ticket must stay 1000"
tm_assert_config_has 'last_ticket[[:space:]]*=[[:space:]]*1499' "the ticket range is fixed by the committee: last_ticket must stay 1499"
tm_apply
[[ "$(tm_state_attr random_integer.winning_ticket min)" == "1000" ]] || tm_fail "random_integer min should be 1000"
[[ "$(tm_state_attr random_integer.winning_ticket max)" == "1499" ]] || tm_fail "random_integer max should be 1499"
W=$(tm_output_raw winning_ticket) || tm_fail "output winning_ticket is missing"
[[ "$W" =~ ^[0-9]+$ ]] && (( W >= 1000 && W <= 1499 )) || tm_fail "winning ticket '$W' is outside 1000-1499"
tm_assert_file_equals hall/winner.txt "Ashby Harvest Fair - winning ticket: $W
"
tm_assert_no_changes
tm_pass "ticket $W drawn from 1000-1499"
