#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'tuple\(\[[[:space:]]*string,[[:space:]]*number,[[:space:]]*bool[[:space:]]*\]\)' \
  "the tuple type [string, number, bool] documents the position contract — keep it as is"

tm_apply
tm_assert_output_jq station_id '. == "north-ridge"' "station_id should be the string north-ridge"
tm_assert_output_jq temp_c 'type == "number" and . == 18.5' "temp_c should be the number 18.5 (not a string)"
tm_assert_output_jq online 'type == "boolean" and . == true' "online should be the boolean true"
tm_assert_file_equals board/status.txt "north-ridge: 18.5 C, sensor online
"
tm_pass "the reading matches the tuple [string, number, bool] in the right positions"
