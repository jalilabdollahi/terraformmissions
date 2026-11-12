#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform still finds a duplicate declaration"
tm_apply
tm_assert_file_equals posters/comet-night.txt $'COMET NIGHT\nFriday 20:00 - Hartley Planetarium, Dome A\nBring a blanket.\n'
tm_assert_file_equals posters/eclipse-tour.txt $'ECLIPSE TOUR\nSaturday 15:30 - Hartley Planetarium, Dome A\nTickets at the door.\n'
n=$(tm_state_list | grep -c '^local_file\.')
[[ "$n" == "2" ]] || tm_fail "state holds $n local_file resources, expected one per show (2)"
tm_assert_in_state local_file.poster "the original comet poster should keep its address local_file.poster"
tm_apply -var 'venue=Dome B'
tm_assert_file_contains posters/eclipse-tour.txt "Dome B" "both posters should still use var.venue"
tm_apply
tm_assert_no_changes
tm_pass "two shows, two distinct resource addresses"
