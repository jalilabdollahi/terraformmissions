#!/usr/bin/env bash
source "$TM_LIB"

for d in north south east west; do
  [[ -n "$(tm_recall "id_$d")" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"
done

tm_assert_config_has 'west' "the west station must stay in the configuration"
tm_assert_config_lacks 'ignore_changes' "lifecycle tricks hide the problem instead of recovering the ring"

if ! terraform state list >"$TM_TMP/sl.txt" 2>"$TM_TMP/sl.err"; then
  tm_fail "Terraform still cannot read the state file: $(head -c 200 "$TM_TMP/sl.err")"
fi

for d in north south east west; do
  tm_assert_in_state "random_id.trigger[\"$d\"]" "trigger serial for station '$d' is not tracked in state"
  tm_assert_in_state "local_file.calibration[\"$d\"]" "calibration file for station '$d' is not tracked in state"
  cur=$(tm_state_attr "random_id.trigger[\"$d\"]" id)
  [[ "$cur" == "$(tm_recall "id_$d")" ]] \
    || tm_fail "station '$d' now has a different trigger serial than the one burned into its firmware"
done
tm_assert_in_state local_file.ring_roster

tm_assert_no_destroy
TM_MSG="plan still has pending changes — the recovered state and the code are not in agreement" tm_assert_no_changes

W=$(tm_recall id_west)
tm_assert_file_contains calibration/station-west.cfg "TG-$W" "station-west.cfg does not carry the original serial"
tm_assert_file_contains calibration/station-north.cfg "1420.4" "north station was never retuned to the current clock"
tm_assert_output_jq ring_serials ".west == \"$W\" and length == 4" "ring_serials output is wrong"
tm_pass "state recovered from backup; all four trigger serials are the originals and the plan is clean"
