#!/usr/bin/env bash
source "$TM_LIB"

# The root already asks for these names; the module is what has to change
tm_assert_config_has 'module\.crier\.next_call' "the root output next_call must keep reading module.crier.next_call"
tm_assert_config_has 'module\.crier\.roster_file' "the root output roster_file must keep reading module.crier.roster_file"

tm_init
TM_MSG="terraform apply failed — which attributes of module.crier does the error say are missing?" tm_apply

tm_assert_in_state module.crier.local_file.roster "the roster must be written by the resource inside module.crier"
tm_assert_output next_call "15:00"
tm_assert_output roster_file "./calls/master-aldous.txt"
tm_assert_file_equals calls/master-aldous.txt $'Master Aldous calls next at 15:00\n'

# The value has to be computed from the hour, not typed into the output
tm_apply -var hour=23
tm_assert_output next_call "00:00"
tm_assert_file_equals calls/master-aldous.txt $'Master Aldous calls next at 00:00\n'
tm_apply -var hour=8
tm_assert_output next_call "09:00"

tm_apply
tm_assert_no_changes
tm_pass "module.crier exposes next_call and roster_file and they follow the hour"
