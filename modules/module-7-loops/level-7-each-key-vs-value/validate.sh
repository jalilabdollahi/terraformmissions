#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_output cards_written "4"
for who in mara:supervisor joss:attendant pim:attendant odile:mechanic; do
  n=${who%%:*}; r=${who#*:}
  tm_assert_in_state "local_file.duty_card[\"$n\"]" "missing instance local_file.duty_card[\"$n\"]"
  tm_assert_file_equals "cards/$n.txt" "Name: $n
Role: $r
" "cards/$n.txt should name the operator and show the role"
done
tm_assert_no_file cards/attendant.txt "cards/attendant.txt exists - cards are named after operators, not roles"
cnt=$(find cards -type f | wc -l | tr -d ' ')
[[ "$cnt" == "4" ]] || tm_fail "expected four cards, found $cnt"
tm_plan_json -var 'crew={ben="cashier",ines="cashier"}'
jq -e '[.resource_changes[] | select(.address == "local_file.duty_card[\"ines\"]") | .change.after.filename | endswith("cards/ines.txt")] == [true]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "with a different crew, each card should still be named after its operator"
tm_pass "each operator gets cards/<name>.txt with their role inside"
