#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform still rejects the configuration — check every top-level block keyword"
tm_assert_config_has '^[[:space:]]*variable[[:space:]]+"lane"' "the lane input variable must be declared"
tm_assert_config_has '^[[:space:]]*output[[:space:]]+"booking_path"' "the booking_path output must be declared"
tm_apply
tm_assert_file_equals lanes/booking.txt $'Lane: Lane 4 (fast, 25 m)\nSlot length: 3h\n'
tm_assert_output_jq booking_path 'endswith("lanes/booking.txt")' "output booking_path should point at lanes/booking.txt"
# the variable must really be wired in, not hard-coded
tm_apply -var 'lane=Lane 1 (slow, 25 m)'
tm_assert_file_contains lanes/booking.txt "Lane: Lane 1 (slow, 25 m)" "the booking sheet ignores the lane variable"
tm_apply
tm_assert_no_changes
tm_pass "variable and output blocks are recognised and the booking sheet is written"
