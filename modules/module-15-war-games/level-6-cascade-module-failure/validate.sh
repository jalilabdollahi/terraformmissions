#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall belt_B1)" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'total_capacity[[:space:]]*=[[:space:]]*"?[0-9]+' "total capacity must be computed, not typed in"
tm_assert_config_lacks 'value[[:space:]]*=[[:space:]]*"(transfer|arrivals)"' "the busiest sorter must be computed"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks hide the cascade instead of fixing it"

tm_validate "the module tree does not validate yet - every layer must be fixed"

for b in B1 B2 B3 B4; do
  cur=$(tm_state_attr "module.belts.random_id.belt[\"$b\"]" id)
  [[ -n "$cur" && "$cur" == "$(tm_recall "belt_$b")" ]] \
    || tm_fail "belt $b no longer has the serial engraved on its controller"
done
for s in transfer arrivals; do
  cur=$(tm_state_attr "module.sorters.random_pet.sorter[\"$s\"]" id)
  [[ "$cur" == "$(tm_recall "pet_$s")" ]] || tm_fail "sorter '$s' was replaced"
done

tm_assert_no_destroy
TM_MSG="plan is not clean - the cascade is not fully resolved" tm_assert_no_changes

tm_assert_output total_capacity 130
tm_assert_output busiest_sorter transfer
tm_assert_output_jq belt_serials 'length == 4 and (to_entries | all(.value | test("^[0-9a-f]{6}$")))' "belt_serials output has the wrong shape (serials are 3 bytes)"
tm_assert_file_contains sortation/dispatch-board.txt "total 130 bpm, busiest transfer" "dispatch board shows wrong numbers"
tm_assert_file_contains sortation/transfer.txt "cap=40" "sorter plan for transfer is wrong"
tm_assert_file_contains sortation/arrivals.txt "cap=20"
tm_pass "A, B and C all repaired; belt serials untouched; dispatch board correct"
