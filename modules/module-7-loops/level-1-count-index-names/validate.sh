#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_config_has 'count[[:space:]]*=' "the cards should still be produced by one counted resource"
tm_apply
for i in 0 1 2 3; do
  tm_assert_in_state "local_file.clue_card[$i]" "local_file.clue_card[$i] is missing from state"
  tm_assert_file "cards/clue-$i.txt" "cards/clue-$i.txt was not written - every card needs its own file name"
done
tm_assert_file_contains cards/clue-0.txt "The pendulum stops at midnight"
tm_assert_file_contains cards/clue-3.txt "Wind the key to the left"
n=$(find cards -type f | wc -l | tr -d ' ')
[[ "$n" == "4" ]] || tm_fail "expected exactly 4 card files in cards/, found $n"
tm_assert_output_jq card_files 'length == 4 and (unique | length) == 4' "card_files should list four different paths"
# a longer clue list must produce a fifth, uniquely named card
tm_plan_json -var 'clues=["a","b","c","d","e"]'
jq -e '[.resource_changes[] | select(.address == "local_file.clue_card[4]") | .change.after.filename | endswith("cards/clue-4.txt")] == [true]' \
  "$TM_TMP/plan.json" >/dev/null || tm_fail "a fifth clue should be planned as card cards/clue-4.txt"
tm_pass "four clue cards, each in its own cards/clue-N.txt, and the name follows count.index"
