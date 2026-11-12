#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"[[:space:]]+"sample"' "the sheets must be read with the local_file data source"
tm_assert_config_has 'for_each[[:space:]]*=' "the sample data source should keep using for_each"
tm_assert_config_lacks 'b07-oak|b12-chestnut|b15-oak' "barrels must be discovered from samples/, not listed by hand"

tm_apply
tm_assert_output_jq brix '. == {"b07-oak":23.4,"b12-chestnut":24.1,"b15-oak":22.8}' \
  "brix should be a map of barrel id (no .txt) to its brix reading"
tm_assert_output average_brix "23.43"
tm_assert_file_contains cellar/board.txt "Barrels sampled: 3"
tm_assert_file_contains cellar/board.txt "b12-chestnut: 24.1 brix"

# A new sheet must be picked up automatically.
trap 'rm -f samples/b21-acacia.txt' EXIT
printf 'brix: 24.9\nacid_gl: 5.2\n' > samples/b21-acacia.txt
tm_apply
tm_assert_output_jq brix '.["b21-acacia"] == 24.9 and length == 4' "a sheet added to samples/ did not show up in brix"
tm_assert_output average_brix "23.80"
tm_assert_file_contains cellar/board.txt "Barrels sampled: 4"
tm_pass "every sheet in samples/ becomes a keyed data source instance"
