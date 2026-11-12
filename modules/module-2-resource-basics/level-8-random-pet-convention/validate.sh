#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "random_pet" "jenny"' "random_pet.jenny must stay"
tm_assert_config_has 'resource "random_pet" "jack"' "random_pet.jack must stay"
tm_apply
A=$(tm_output_raw jenny_nickname) || tm_fail "output jenny_nickname is missing"
B=$(tm_output_raw jack_nickname) || tm_fail "output jack_nickname is missing"
RE='^donkey-[a-z]+-[a-z]+$'
[[ "$A" =~ $RE ]] || tm_fail "jenny nickname '$A' does not match donkey-<word>-<word>"
[[ "$B" =~ $RE ]] || tm_fail "jack nickname '$B' does not match donkey-<word>-<word>"
[[ "$A" == "$(tm_state_attr random_pet.jenny id)" ]] || tm_fail "output jenny_nickname is not the pet's id"
tm_assert_file_equals calendar/donkeys.txt "jenny: $A
jack: $B
"
tm_assert_no_changes
tm_pass "nicknames $A and $B follow the sponsor-card convention"
