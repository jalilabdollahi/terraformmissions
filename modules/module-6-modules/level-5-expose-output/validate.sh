#!/usr/bin/env bash
source "$TM_LIB"

# The root already asks for these names; the module is what has to change
tm_assert_config_has 'module\.tower\.next_chime' "the root output next_chime must keep reading module.tower.next_chime"
tm_assert_config_has 'module\.tower\.roster_file' "the root output roster_file must keep reading module.tower.roster_file"

tm_init
TM_MSG="terraform apply failed — which attributes of module.tower does the error say are missing?" tm_apply

tm_assert_in_state module.tower.local_file.roster "the roster must be written by the resource inside module.tower"
tm_assert_output next_chime "15:00"
tm_assert_output roster_file "./chimes/saint-aldric.txt"
tm_assert_file_equals chimes/saint-aldric.txt $'Saint Aldric rings next at 15:00\n'

# The value has to be computed from the hour, not typed into the output
tm_apply -var hour=23
tm_assert_output next_chime "00:00"
tm_assert_file_equals chimes/saint-aldric.txt $'Saint Aldric rings next at 00:00\n'
tm_apply -var hour=8
tm_assert_output next_chime "09:00"

tm_apply
tm_assert_no_changes
tm_pass "module.tower exposes next_chime and roster_file and they follow the hour"
