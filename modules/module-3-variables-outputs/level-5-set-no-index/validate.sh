#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'set\(string\)' "donated_genres should stay a set(string)"
tm_assert_config_lacks '"animation"[[:space:]]*$|featured[[:space:]]*=[[:space:]]*"' "the featured genre must be computed from the set, not typed in"

tm_apply
tm_assert_output featured_genre "animation"
tm_assert_output genre_count "4"
tm_assert_file_equals window/featured.txt "Reel Deal Video Branch - featured this month: animation
"

tm_plan_json -var 'donated_genres=["thriller","documentary","zombie"]'
[[ "$(jq -r '.planned_values.outputs.featured_genre.value' "$TM_TMP/plan.json")" == "documentary" ]] \
  || tm_fail "with a different genre set the featured genre should be the alphabetically first ('documentary')"
tm_pass "the featured genre is the alphabetically first member of the set"
