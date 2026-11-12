#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"local_file"' "the sheet must still be read back through a local_file data source"
tm_assert_config_lacks '14\.4' "the dose has to be computed from the sheet, not typed in"

tm_apply
tm_assert_output fragrance_g 14.4
tm_assert_file_contains bench/dose-label.txt "14.4 g for 240 g of base"

# New base weight: the sheet is rewritten and the data source must see the NEW content in the same apply.
tm_apply -var base_grams=500
tm_assert_output fragrance_g 30
tm_assert_file_contains bench/dose-label.txt "30 g for 500 g of base" "the dose label is built from a stale batch sheet"

tm_apply -var base_grams=180
tm_assert_output fragrance_g 10.8
TM_MSG="plan is not clean after the apply" tm_assert_no_changes -var base_grams=180
tm_pass "the data source follows the batch sheet written in the same run"
