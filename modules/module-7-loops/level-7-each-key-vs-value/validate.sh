#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
tm_assert_output cards_written "4"
for who in mara:captain joss:deckhand pim:deckhand odile:engineer; do
  n=${who%%:*}; r=${who#*:}
  tm_assert_in_state "local_file.duty_card[\"$n\"]" "missing instance local_file.duty_card[\"$n\"]"
  tm_assert_file_equals "cards/$n.txt" "Name: $n
Role: $r
" "cards/$n.txt should name the sailor and show the role"
done
tm_assert_no_file cards/deckhand.txt "cards/deckhand.txt exists - cards are named after sailors, not roles"
cnt=$(find cards -type f | wc -l | tr -d ' ')
[[ "$cnt" == "4" ]] || tm_fail "expected four cards, found $cnt"
tm_plan_json -var 'crew={ben="cook",ines="cook"}'
jq -e '[.resource_changes[] | select(.address == "local_file.duty_card[\"ines\"]") | .change.after.filename | endswith("cards/ines.txt")] == [true]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "with a different crew, each card should still be named after its sailor"
tm_pass "each sailor gets cards/<name>.txt with their role inside"
