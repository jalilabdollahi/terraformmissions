#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "a character-class argument still has a value that is not a boolean"
tm_assert_config_has 'lower[[:space:]]*=[[:space:]]*false' "lowercase letters must be switched off with lower = false"
tm_assert_config_has 'special[[:space:]]*=[[:space:]]*false' "special characters must be switched off with special = false"
tm_apply
v=$(tm_output_raw voucher) || tm_fail "output voucher is missing"
[[ "$v" =~ ^[A-Z0-9]{8}$ ]] || tm_fail "voucher '$v' is not 8 characters of capital letters and digits"
tm_assert_file_equals hostel/voucher-slip.txt "Driftwood Hostel guest Wi-Fi"$'\n'"Voucher: ${v}"$'\n'
tm_assert_no_changes
tm_pass "voucher $v uses only capital letters and digits"
