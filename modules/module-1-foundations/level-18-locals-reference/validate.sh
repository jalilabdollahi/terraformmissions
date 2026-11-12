#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '^[[:space:]]*locals[[:space:]]*\{' "named constants are declared with a locals { } block (plural)"
tm_assert_config_lacks '^[[:space:]]*local[[:space:]]*\{' "'local {' is not a valid block"
tm_assert_config_lacks 'locals\.' "values are read with local.<name> (singular), not locals.<name>"
tm_assert_config_has 'wheel_price[[:space:]]*=[[:space:]]*local\.' "wheel_price must be computed from the other locals, not typed in"
tm_validate "terraform still rejects the locals declaration or a reference to it"
tm_apply
tm_assert_file_equals cellar/wheel-label.txt $'Tomme de Fenwick\nRind: washed\nWeight: 8 kg\nPrice: 248 EUR\n'
tm_assert_output wheel_price 248
tm_assert_no_changes
tm_pass "locals are declared and read correctly, and the price is computed"
