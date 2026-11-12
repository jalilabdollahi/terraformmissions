#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"external"' "the weigh-in must still go through the external data source"
tm_assert_config_has 'query[[:space:]]*=' "the external program receives its input through the data source's query"

tm_apply
tm_assert_output flying_weight_g 959
tm_assert_output advice "hold back the next feed"
tm_assert_file_contains mews/weigh-in.txt "Bird: Saker falcon Tamsin" "weigh-in.txt does not name the bird"
tm_assert_file_contains mews/weigh-in.txt "Grams to lose: 61 g"

# Different inputs must produce different answers: the variables really reach the program.
tm_apply -var 'bird=Peregrine Oriel' -var weight_g=700 -var target_pct=100
tm_assert_output flying_weight_g 700
tm_assert_output advice "ready to fly"
tm_assert_file_contains mews/weigh-in.txt "Bird: Peregrine Oriel" "the bird name did not reach the program"
tm_apply -var weight_g=1100 -var target_pct=90
tm_assert_output flying_weight_g 990
tm_assert_file_contains mews/weigh-in.txt "Grams to lose: 110 g"
tm_pass "the program receives bird, weight_g and target_pct through the query"
