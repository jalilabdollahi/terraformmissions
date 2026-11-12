#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"[[:space:]]+"sample"' "the sheets must be read with the local_file data source"
tm_assert_config_has 'for_each[[:space:]]*=' "the sample data source should keep using for_each"
tm_assert_config_lacks 'l07-kelp|l12-dulse|l15-kelp' "longlines must be discovered from samples/, not listed by hand"

tm_apply
tm_assert_output_jq growth '. == {"l07-kelp":23.4,"l12-dulse":24.1,"l15-kelp":22.8}' \
  "growth should be a map of longline id (no .txt) to its growth reading"
tm_assert_output average_growth "23.43"
tm_assert_file_contains farm/board.txt "Longlines sampled: 3"
tm_assert_file_contains farm/board.txt "l12-dulse: 24.1 cm"

# A new sheet must be picked up automatically.
trap 'rm -f samples/l21-nori.txt' EXIT
printf 'growth: 24.9\nnitrate: 5.2\n' > samples/l21-nori.txt
tm_apply
tm_assert_output_jq growth '.["l21-nori"] == 24.9 and length == 4' "a sheet added to samples/ did not show up in growth"
tm_assert_output average_growth "23.80"
tm_assert_file_contains farm/board.txt "Longlines sampled: 4"
tm_pass "every sheet in samples/ becomes a keyed data source instance"
