#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'first_card[[:space:]]*=[[:space:]]*1000' "the card range is fixed by management: first_card must stay 1000"
tm_assert_config_has 'last_card[[:space:]]*=[[:space:]]*1499' "the card range is fixed by management: last_card must stay 1499"
tm_apply
[[ "$(tm_state_attr random_integer.winning_card min)" == "1000" ]] || tm_fail "random_integer min should be 1000"
[[ "$(tm_state_attr random_integer.winning_card max)" == "1499" ]] || tm_fail "random_integer max should be 1499"
W=$(tm_output_raw winning_card) || tm_fail "output winning_card is missing"
[[ "$W" =~ ^[0-9]+$ ]] && (( W >= 1000 && W <= 1499 )) || tm_fail "winning card '$W' is outside 1000-1499"
tm_assert_file_equals hall/winner.txt "Lucky Strike Bingo - winning card: $W
"
tm_assert_no_changes
tm_pass "card $W drawn from 1000-1499"
