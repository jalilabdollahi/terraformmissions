#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform still finds a duplicate declaration"
tm_apply
tm_assert_file_equals flash/swallow.txt $'SWALLOW\nFriday 18:00 - Inkwell Row Tattoo, Booth A\nWalk-ins welcome.\n'
tm_assert_file_equals flash/anchor.txt $'ANCHOR\nSaturday 12:30 - Inkwell Row Tattoo, Booth A\nDeposit due at booking.\n'
n=$(tm_state_list | grep -c '^local_file\.')
[[ "$n" == "2" ]] || tm_fail "state holds $n local_file resources, expected one per design (2)"
tm_assert_in_state local_file.flash_sheet "the original swallow sheet should keep its address local_file.flash_sheet"
tm_apply -var 'venue=Booth B'
tm_assert_file_contains flash/anchor.txt "Booth B" "both flash sheets should still use var.venue"
tm_apply
tm_assert_no_changes
tm_pass "two designs, two distinct resource addresses"
