#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'formatlist[[:space:]]*\(' "keep using formatlist() for the price lines"

tm_apply
tm_assert_output_jq price_lines '. == ["Members — GBP 45.00","Grandstand — GBP 30.00","Silver Ring — GBP 18.50"]' \
  "price_lines should be: Members — GBP 45.00, Grandstand — GBP 30.00, Silver Ring — GBP 18.50"
tm_assert_file_equals board/prices.txt "Members — GBP 45.00
Grandstand — GBP 30.00
Silver Ring — GBP 18.50
"

# The currency is one variable, and the number of tiers is not fixed at three.
tm_plan_json -var 'tiers=["Hospitality","Members","Grandstand","Paddock","Course Rail"]' \
  -var 'prices=[90,60,40,25,12]' -var currency=EUR
tm_assert_output_jq_plan() { jq -e "$1" "$TM_TMP/plan.json" >/dev/null || tm_fail "$2"; }
tm_assert_output_jq_plan '.planned_values.outputs.price_lines.value == ["Hospitality — EUR 90.00","Members — EUR 60.00","Grandstand — EUR 40.00","Paddock — EUR 25.00","Course Rail — EUR 12.00"]' \
  "with 5 tiers and currency EUR every tier needs its own line ending in the EUR code"
tm_pass "every tier gets its price line with the shared currency, however many tiers there are"
