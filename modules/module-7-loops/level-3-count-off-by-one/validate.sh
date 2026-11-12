#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_no_file signs/bay-00.txt "signs/bay-00.txt exists - there is no bay zero"
for n in 1 2 3 4 5 6; do
  tm_assert_file "signs/bay-0$n.txt" "signs/bay-0$n.txt is missing"
  tm_assert_file_equals "signs/bay-0$n.txt" "BAY $n of 6
"
done
# resource addresses stay zero-based; only the labels are shifted
tm_assert_in_state 'local_file.bay_sign[5]' "sign for the last bay should live at local_file.bay_sign[5]"
tm_assert_not_in_state 'local_file.bay_sign[6]' "there should be exactly six signs"
tm_assert_output_jq last_sign 'endswith("signs/bay-06.txt")' "last_sign should point at signs/bay-06.txt"
tm_plan_json -var bays=9
jq -e '[.resource_changes[] | select(.address == "local_file.bay_sign[8]") | .change.after.content] == ["BAY 9 of 9\n"]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "with 9 bays, the last sign should read 'BAY 9 of 9'"
tm_pass "bays are labelled 1 to 6 while the instances stay [0] to [5]"
