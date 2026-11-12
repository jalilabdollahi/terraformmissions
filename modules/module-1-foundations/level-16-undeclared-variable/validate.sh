#!/usr/bin/env bash
source "$TM_LIB"

for v in race_city runner_count first_bib; do
  tm_assert_config_has "variable[[:space:]]+\"$v\"" "variable \"$v\" is not declared anywhere"
done
tm_assert_config_has 'var\.runner_count' "main.tf must keep reading var.runner_count"
tm_validate "terraform still reports undeclared variables"
tm_apply
tm_assert_file_equals race/sheet.txt $'Ribeira River Run - Porto\nRunners registered: 1200\n'
tm_assert_file_equals race/bibs.txt $'Bibs 1001 to 2200\n'
tm_assert_output bib_range "1001-2200"
tm_assert_output city "Porto"
# prove the values really flow from the variables
tm_apply -var race_city=Lisbon -var runner_count=500 -var first_bib=1
tm_assert_file_equals race/bibs.txt $'Bibs 1 to 500\n'
tm_assert_file_contains race/sheet.txt "Lisbon"
tm_apply
tm_assert_no_changes
tm_pass "all three variables are declared with the right defaults and types"
