#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'csvdecode' "the passes must still be parsed from the CSV in the config"
tm_assert_config_lacks '"(KESTREL|HERON|OSPREY|TERN)-[0-9]' "satellite names may not be typed into expressions - compute them from the data"

tm_validate "the configuration does not evaluate yet"
tm_apply
tm_assert_no_changes
tm_assert_no_changes

tm_assert_output_jq longest_windows '. == ["HERON-3","OSPREY-5","HERON-4"]' \
  "longest_windows is $(tm_output_json longest_windows) - expected the three longest usable windows, longest first"
tm_assert_output_jq total_usable_minutes '. == 239' "total_usable_minutes is wrong - only usable passes count"
tm_assert_output_jq per_family_minutes '. == {"HERON":[120,15],"KESTREL":[9],"OSPREY":[88,7]}' \
  "per_family_minutes should list numeric minutes per family: $(tm_output_json per_family_minutes)"
tm_assert_file_equals downlink/booking.txt $'HERON-3\nOSPREY-5\nHERON-4\n' \
  "downlink/booking.txt must list the booked satellites, one per line"
tm_pass "the expressions now return what the planners expect"
