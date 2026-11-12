#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the note must still be read through a local_file data source"
grep -q 'data[[:space:]]*"local_file"' modules/lock-notes/main.tf 2>/dev/null \
  || tm_fail "the data source must live inside modules/lock-notes"
if grep -q 'jsondecode' main.tf 2>/dev/null; then tm_fail "the root config should use the module's output, not decode the notes itself"; fi

tm_apply
tm_assert_output lowest_level_cm 148
tm_assert_output_jq open_gates '. == ["north"]' "open_gates should be [\"north\"]"
tm_assert_file_contains log/watch.txt "North lock (Edda Vance): 212 cm"
tm_assert_file_contains log/watch.txt "South lock (Rufus Ashby): 148 cm"

cp notes/south-lock.json "$TM_TMP/south.orig"
trap 'cp "$TM_TMP/south.orig" notes/south-lock.json' EXIT
echo '{"keeper": "Ida Mott", "level_cm": 301, "gates_open": true}' > notes/south-lock.json
tm_apply
tm_assert_output lowest_level_cm 212
tm_assert_output_jq open_gates '. == ["north","south"]' "open_gates did not follow the edited south note"
tm_assert_file_contains log/watch.txt "South lock (Ida Mott): 301 cm"
tm_pass "the root config consumes the module's reading output"
