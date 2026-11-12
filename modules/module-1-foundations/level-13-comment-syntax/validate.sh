#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_lacks '^[[:space:]]*--' "'--' is a SQL comment, not an HCL one"
tm_assert_config_lacks '^[[:space:]]*;' "';' starts an INI comment, not an HCL one"
tm_assert_config_lacks '<!--' "HTML comments are not valid HCL"
tm_validate "the file still has text Terraform cannot parse — look for comment styles from other languages"
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"price_list"' "keep the price_list resource"
tm_apply
tm_assert_file_equals shop/price-list.csv $'Blue Train,33.00\nKind of Blue,26.40\nRumours,19.80\n'
tm_assert_output record_count 3
tm_apply -var markup_pct=0
tm_assert_file_contains shop/price-list.csv "Blue Train,30.00" "markup_pct must still drive the prices"
tm_apply
tm_assert_no_changes
tm_pass "comments are valid HCL and the price list is correct"
