#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file extras/depot-notes.tf "extras/depot-notes.tf must stay in the repository (fmt -recursive should reformat it, not delete it)"
tm_assert_file stops.tf "stops.tf must stay in the repository"
if ! terraform fmt -check -recursive -no-color >"$TM_LAST_OUT" 2>&1; then
  echo "   files that are not canonically formatted:"
  tm_show_last
  tm_fail "terraform fmt -check -recursive still reports unformatted files"
fi
tm_assert_config_has 'depot_name' "extras/depot-notes.tf lost its content"
tm_validate
tm_apply
tm_assert_file_equals depot/line-7.txt $'Line 7: first tram 05:40, every 12 min\n1. Harbour Gate\n2. Old Mill\n3. Clocktower\n4. University\n'
tm_assert_file_equals depot/stop-count.txt $'4 stops\n'
tm_assert_output_jq timetable_file 'endswith("depot/line-7.txt")'
tm_assert_no_changes
tm_pass "everything is canonically formatted and the timetable is unchanged"
