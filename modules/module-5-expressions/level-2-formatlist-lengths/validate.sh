#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'formatlist[[:space:]]*\(' "keep using formatlist() for the price lines"

tm_apply
tm_assert_output_jq price_lines '. == ["Weekend Pass — GBP 45.00","Day Ticket — GBP 30.00","Evening Entry — GBP 18.50"]' \
  "price_lines should be: Weekend Pass — GBP 45.00, Day Ticket — GBP 30.00, Evening Entry — GBP 18.50"
tm_assert_file_equals board/prices.txt "Weekend Pass — GBP 45.00
Day Ticket — GBP 30.00
Evening Entry — GBP 18.50
"

# The currency is one variable, and the number of tiers is not fixed at three.
tm_plan_json -var 'tiers=["Steward Guest","Weekend Pass","Day Ticket","Child Ticket","Engine Lawn"]' \
  -var 'prices=[90,60,40,25,12]' -var currency=EUR
tm_assert_output_jq_plan() { jq -e "$1" "$TM_TMP/plan.json" >/dev/null || tm_fail "$2"; }
tm_assert_output_jq_plan '.planned_values.outputs.price_lines.value == ["Steward Guest — EUR 90.00","Weekend Pass — EUR 60.00","Day Ticket — EUR 40.00","Child Ticket — EUR 25.00","Engine Lawn — EUR 12.00"]' \
  "with 5 tiers and currency EUR every tier needs its own line ending in the EUR code"
tm_pass "every tier gets its price line with the shared currency, however many tiers there are"
