#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "the configuration still does not parse — read the line numbers in the error"
tm_assert_config_has 'resource "local_file" "dough_card"' "the dough_card resource must stay in the config"
tm_assert_config_has 'resource "local_file" "oven_schedule"' "the oven_schedule resource must stay in the config"
tm_apply
tm_assert_file_equals bakery/oven-schedule.txt $'05:30 sourdough\n06:15 rye\n07:00 focaccia\n'
tm_assert_file_contains bakery/dough-card.txt "750g flour" "bakery/dough-card.txt is missing"
tm_assert_output_jq schedule_file 'endswith("bakery/oven-schedule.txt")'
tm_assert_no_changes
tm_pass "the bakery schedule is printed and the config parses"
