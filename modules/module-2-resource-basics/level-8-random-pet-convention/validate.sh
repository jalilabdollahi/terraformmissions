#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_pet" "refractor"' "random_pet.refractor must stay"
tm_assert_config_has 'resource "random_pet" "reflector"' "random_pet.reflector must stay"
tm_apply
A=$(tm_output_raw refractor_nickname) || tm_fail "output refractor_nickname is missing"
B=$(tm_output_raw reflector_nickname) || tm_fail "output reflector_nickname is missing"
RE='^scope-[a-z]+-[a-z]+$'
[[ "$A" =~ $RE ]] || tm_fail "refractor nickname '$A' does not match scope-<word>-<word>"
[[ "$B" =~ $RE ]] || tm_fail "reflector nickname '$B' does not match scope-<word>-<word>"
[[ "$A" == "$(tm_state_attr random_pet.refractor id)" ]] || tm_fail "output refractor_nickname is not the pet's id"
tm_assert_file_equals calendar/instruments.txt "refractor: $A
reflector: $B
"
tm_assert_no_changes
tm_pass "nicknames $A and $B follow the booking convention"
