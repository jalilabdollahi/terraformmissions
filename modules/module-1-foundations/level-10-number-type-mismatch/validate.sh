#!/usr/bin/env bash
source "$TM_LIB"

tm_validate "terraform still finds a value that cannot be a number"
tm_assert_config_has 'variable[[:space:]]+"teams"' "keep the teams variable"
tm_assert_config_has 'resource[[:space:]]+"random_shuffle"[[:space:]]+"round_one"' "keep the random_shuffle.round_one resource"
tm_apply
tm_assert_output team_count 8
tm_assert_output_jq picked_questions 'length == 3 and (unique | length) == 3' "exactly 3 distinct questions should be picked"
tm_assert_file_contains quiz/round-one.txt "Teams registered: 8"
lines=$(wc -l < quiz/round-one.txt | tr -d ' ')
[[ "$lines" == "4" ]] || tm_fail "quiz/round-one.txt should have the team line plus 3 questions (4 lines), found $lines"
tm_apply -var teams=12
tm_assert_output team_count 12
tm_apply
tm_assert_no_changes
tm_pass "teams and the number of questions are real numbers"
