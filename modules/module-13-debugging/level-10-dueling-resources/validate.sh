#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'local\.intro' "the standing text must still come from local.intro"
tm_assert_config_has 'local\.events' "the event list must still come from local.events"
tm_assert_config_lacks 'ignore_changes' "ignore_changes would hide the fight instead of ending it"

tm_apply
tm_assert_no_changes
tm_assert_no_changes
tm_assert_no_changes

OWNERS=$(terraform show -json | jq '[.values.root_module.resources[]? | select(.type == "local_file") | select(.values.filename | test("board/notices.md$"))] | length')
[[ "$OWNERS" == "1" ]] || tm_fail "$OWNERS resources manage board/notices.md - exactly one resource must own it"

EXPECTED=$'# Community Centre notices\nOpen weekdays 9 to 5 in the main hall.\n\n## Events\n- 14 Nov: winter coat drive\n- 28 Nov: toy swap\n'
tm_assert_file_equals board/notices.md "$EXPECTED" "board/notices.md must hold the intro, a blank line, then the events list"
tm_assert_output board_path "./board/notices.md"
tm_pass "one resource owns the noticeboard and plans are stable"
