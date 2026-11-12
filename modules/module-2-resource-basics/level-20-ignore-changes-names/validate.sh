#!/usr/bin/env bash
source "$TM_LIB"

ORIG=$(tm_recall notes)
[[ -n "$ORIG" ]] || tm_fail "mission state is missing: run 'reset' to restore the level"
tm_assert_config_has 'ignore_changes[[:space:]]*=[[:space:]]*\[[[:space:]]*content[[:space:]]*\]' "ignore_changes must name the real attribute 'content' of local_file.build_notes"
tm_assert_config_lacks 'ignore_changes[[:space:]]*=[[:space:]]*all' "ignore_changes = all would also freeze things that should follow the config"
tm_assert_config_has 'shift_length_hours[[:space:]]*=[[:space:]]*12' "the new 12 hour schedule must stay in the config"
tm_apply
tm_assert_no_changes
[[ "$(cat journal/build-notes.txt)" == "$ORIG" ]] || tm_fail "journal/build-notes.txt was overwritten: the mechanic's original line must be preserved"
tm_assert_file_equals journal/schedule.txt "Change shifts every 12 hours.
" "journal/schedule.txt does not show the new 12 hour schedule"
tm_pass "notes preserved, schedule updated"
