#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'format[[:space:]]*\(' "the card must be built with format()"

tm_apply
tm_assert_output bib_label "BIB-00007"
tm_assert_output card 'BIB-00007 | "Ines \"Flash\" Okafor" | 021.1 km | pace 4:51 min/km'
tm_assert_file_equals cards/bib-card.txt 'BIB-00007 | "Ines \"Flash\" Okafor" | 021.1 km | pace 4:51 min/km
'

# The card must be computed from the runner, not typed in.
tm_plan_json -var 'runner={name="Tomas",bib=1234,distance_km=10,pace_seconds=305}'
[[ "$(jq -r '.planned_values.outputs.bib_label.value' "$TM_TMP/plan.json")" == "BIB-01234" ]] \
  || tm_fail "bib 1234 should print as BIB-01234 (five digits, zero padded)"
[[ "$(jq -r '.planned_values.outputs.card.value' "$TM_TMP/plan.json")" == 'BIB-01234 | "Tomas" | 010.0 km | pace 5:05 min/km' ]] \
  || tm_fail "a 10 km runner named Tomas should print as: BIB-01234 | \"Tomas\" | 010.0 km | pace 5:05 min/km"
tm_pass "bib cards are formatted from the runner's data with the right verbs"
