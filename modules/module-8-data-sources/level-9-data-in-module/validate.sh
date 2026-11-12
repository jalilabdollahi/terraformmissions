#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the note must still be read through a local_file data source"
grep -q 'data[[:space:]]*"local_file"' modules/ranger-notes/main.tf 2>/dev/null \
  || tm_fail "the data source must live inside modules/ranger-notes"
if grep -q 'jsondecode' main.tf 2>/dev/null; then tm_fail "the root config should use the module's output, not decode the notes itself"; fi

tm_apply
tm_assert_output lowest_snow_cm 148
tm_assert_output_jq open_trails '. == ["north"]' "open_trails should be [\"north\"]"
tm_assert_file_contains log/patrol.txt "North trail (Edda Vance): 212 cm"
tm_assert_file_contains log/patrol.txt "South trail (Rufus Ashby): 148 cm"

cp notes/south-trail.json "$TM_TMP/south.orig"
trap 'cp "$TM_TMP/south.orig" notes/south-trail.json' EXIT
echo '{"ranger": "Ida Mott", "snow_cm": 301, "trail_open": true}' > notes/south-trail.json
tm_apply
tm_assert_output lowest_snow_cm 212
tm_assert_output_jq open_trails '. == ["north","south"]' "open_trails did not follow the edited south note"
tm_assert_file_contains log/patrol.txt "South trail (Ida Mott): 301 cm"
tm_pass "the root config consumes the module's reading output"
