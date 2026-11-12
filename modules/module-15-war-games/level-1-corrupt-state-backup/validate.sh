#!/usr/bin/env bash
source "$TM_LIB"

for d in north south east west; do
  [[ -n "$(tm_recall "id_$d")" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"
done

tm_assert_config_has 'west' "the west dish must stay in the configuration"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks hide the problem instead of recovering the array"

if ! terraform state list >"$TM_TMP/sl.txt" 2>"$TM_TMP/sl.err"; then
  tm_fail "Terraform still cannot read the state file: $(head -c 200 "$TM_TMP/sl.err")"
fi

for d in north south east west; do
  tm_assert_in_state "random_id.receiver[\"$d\"]" "receiver serial for dish '$d' is not tracked in state"
  tm_assert_in_state "local_file.calibration[\"$d\"]" "calibration file for dish '$d' is not tracked in state"
  cur=$(tm_state_attr "random_id.receiver[\"$d\"]" id)
  [[ "$cur" == "$(tm_recall "id_$d")" ]] \
    || tm_fail "dish '$d' now has a different receiver serial than the one burned into its firmware"
done
tm_assert_in_state local_file.array_roster

tm_assert_no_destroy
TM_MSG="plan still has pending changes — the recovered state and the code are not in agreement" tm_assert_no_changes

W=$(tm_recall id_west)
tm_assert_file_contains calibration/dish-west.cfg "RX-$W" "dish-west.cfg does not carry the original serial"
tm_assert_file_contains calibration/dish-north.cfg "1420.4" "north dish was never retuned to the current band"
tm_assert_output_jq array_serials ".west == \"$W\" and length == 4" "array_serials output is wrong"
tm_pass "state recovered from backup; all four receiver serials are the originals and the plan is clean"
