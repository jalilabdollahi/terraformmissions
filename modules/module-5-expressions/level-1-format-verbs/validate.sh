#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'format[[:space:]]*\(' "the card must be built with format()"

tm_apply
tm_assert_output tag_label "TAG-00007"
tm_assert_output card 'TAG-00007 | "Ines \"Flash\" Okafor" | 021.1 km | pace 4:51 min/km'
tm_assert_file_equals cards/route-card.txt 'TAG-00007 | "Ines \"Flash\" Okafor" | 021.1 km | pace 4:51 min/km
'

# The card must be computed from the rider, not typed in.
tm_plan_json -var 'rider={name="Tomas",tag=1234,distance_km=10,pace_seconds=305}'
[[ "$(jq -r '.planned_values.outputs.tag_label.value' "$TM_TMP/plan.json")" == "TAG-01234" ]] \
  || tm_fail "tag 1234 should print as TAG-01234 (five digits, zero padded)"
[[ "$(jq -r '.planned_values.outputs.card.value' "$TM_TMP/plan.json")" == 'TAG-01234 | "Tomas" | 010.0 km | pace 5:05 min/km' ]] \
  || tm_fail "a 10 km rider named Tomas should print as: TAG-01234 | \"Tomas\" | 010.0 km | pace 5:05 min/km"
tm_pass "tag cards are formatted from the rider's data with the right verbs"
