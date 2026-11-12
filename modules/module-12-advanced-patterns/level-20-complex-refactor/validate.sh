#!/usr/bin/env bash
source "$TM_LIB"

MASCOT=$(tm_recall mascot)
[[ -n "$MASCOT" && -n "$(tm_recall token_claw)" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks '^[[:space:]]*count[[:space:]]*=' "the refactor to for_each must stay: no count"
tm_assert_config_has 'moved[[:space:]]*\{' "use moved blocks for the count -> for_each migration"
tm_assert_config_has 'removed[[:space:]]*\{' "use a removed block for the mascot"
tm_assert_config_has 'destroy[[:space:]]*=[[:space:]]*false' "the mascot must be forgotten, not destroyed"
tm_assert_config_has 'import[[:space:]]*\{' "use an import block for the jackpot"
tm_assert_config_lacks 'resource[[:space:]]+"random_pet"' "the mascot must no longer be a managed resource"

TM_MSG="the plan destroys or replaces an existing object: the refactor is not fully described" tm_assert_no_destroy
tm_apply

for name in skee-ball claw racer; do
  tm_assert_in_state "random_id.token[\"$name\"]"
  tm_assert_in_state "local_file.cabinet_card[\"$name\"]"
  [[ "$(tm_state_attr "random_id.token[\"$name\"]" hex)" == "$(tm_recall token_$name)" ]] || tm_fail "the token of '$name' changed"
  [[ "$(tm_state_attr "local_file.cabinet_card[\"$name\"]" id)" == "$(tm_recall card_$name)" ]] || tm_fail "the card of '$name' was recreated"
  tm_assert_file_contains "cards/$name.txt" "token $(tm_recall token_$name)"
done
STATE=$(tm_state_list)
grep -q '\[[0-9]\]' <<<"$STATE" && tm_fail "some objects are still tracked under numeric count indexes"
tm_assert_not_in_state random_pet.mascot "the mascot is still in state (it must be forgotten)"
[[ "$(tm_state_attr random_integer.jackpot result)" == "7421" ]] || tm_fail "the jackpot is not 7421: it was generated, not adopted"
tm_assert_output jackpot 7421
tm_assert_no_changes
tm_pass "tokens moved to for_each keys, mascot forgotten, jackpot 7421 adopted, nothing destroyed"
