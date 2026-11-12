#!/usr/bin/env bash
source "$TM_LIB"

[[ -n "$(tm_recall run_ash_failed)" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks '"K4"' "the ash lot is still pointed at a kiln that is not on the allow-list"
tm_assert_config_has 'ash' "the ash lot must still be part of the pipeline"
tm_assert_config_lacks 'on_failure[[:space:]]*=[[:space:]]*continue' "swallowing the handshake failure is not a fix"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks are not a recovery"

tm_validate

for l in oak pine ash; do
  tm_assert_in_state "random_integer.tag[\"$l\"]" "the pallet tag for '$l' is not tracked in state"
  tm_assert_in_state "terraform_data.kiln_run[\"$l\"]" "kiln run for '$l' is not tracked in state"
  tm_assert_in_state "local_file.ticket[\"$l\"]" "yard ticket for '$l' is not tracked in state"
  cur=$(tm_state_attr "random_integer.tag[\"$l\"]" result)
  [[ "$cur" == "$(tm_recall "tag_$l")" ]] \
    || tm_fail "pallet tag for '$l' changed ($(tm_recall "tag_$l") -> $cur); the labels are already on the wood"
done

[[ "$(tm_state_attr 'terraform_data.kiln_run["oak"]' id)" == "$(tm_recall run_oak)" ]] || tm_fail "the oak kiln run was replaced although it was healthy"
[[ "$(tm_state_attr 'terraform_data.kiln_run["pine"]' id)" == "$(tm_recall run_pine)" ]] \
  || tm_fail "the pine kiln run was replaced: its handshake had succeeded and its run ID is referenced downstream"
ASH=$(tm_state_attr 'terraform_data.kiln_run["ash"]' id)
[[ "$ASH" != "$(tm_recall run_ash_failed)" ]] || tm_fail "the ash run still is the one whose handshake failed - it never completed and must be redone"

tm_assert_no_destroy
TM_MSG="plan is not clean after recovery" tm_assert_no_changes

tm_assert_file ledger/handshakes.log
grep -q 'lot=ash kiln=K-4' ledger/handshakes.log || tm_fail "the kiln controller never acknowledged lot ash on K-4"
tm_assert_file_contains tickets/ash.txt "KILN  K-4"
for l in oak pine; do tm_assert_file_contains "tickets/$l.txt" "TAG   $(tm_recall "tag_$l")"; done
tm_assert_output_jq pallet_tags ".pine == $(tm_recall tag_pine) and .oak == $(tm_recall tag_oak) and .ash == $(tm_recall tag_ash)"
tm_pass "pipeline finished: tags intact, healthy runs preserved, ash re-run on K-4, plan clean"
