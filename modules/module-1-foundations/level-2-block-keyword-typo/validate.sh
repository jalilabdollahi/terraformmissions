#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform still rejects the configuration — check every top-level block keyword"
tm_assert_config_has '^[[:space:]]*variable[[:space:]]+"telescope"' "the telescope input variable must be declared"
tm_assert_config_has '^[[:space:]]*output[[:space:]]+"booking_path"' "the booking_path output must be declared"
tm_apply
tm_assert_file_equals sky/booking.txt $'Instrument: Dobsonian 12-inch\nSlot length: 3h\n'
tm_assert_output_jq booking_path 'endswith("sky/booking.txt")' "output booking_path should point at sky/booking.txt"
# the variable must really be wired in, not hard-coded
tm_apply -var 'telescope=Refractor 80mm'
tm_assert_file_contains sky/booking.txt "Instrument: Refractor 80mm" "the booking sheet ignores the telescope variable"
tm_apply
tm_assert_no_changes
tm_pass "variable and output blocks are recognised and the booking sheet is written"
