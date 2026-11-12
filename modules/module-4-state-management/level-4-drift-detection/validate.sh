#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'resource "local_file" "firing_schedule"' "the firing_schedule resource must stay in the configuration"
tm_assert_config_has '1320' "the configuration does not mention the technician's peak temperature"
tm_assert_config_has '\b40\b' "the configuration does not mention the technician's hold time"

# The technician's edit is the truth: the file on disk must still carry it.
tm_assert_file_equals kiln/firing-schedule.txt $'kiln: K2\npeak_temp_c: 1320\nhold_minutes: 40\n' \
  "kiln/firing-schedule.txt no longer holds the technician's values (1320 °C, 40 minutes)"

tm_assert_in_state local_file.firing_schedule "the schedule is not tracked in state — apply the reconciled configuration"
tm_assert_in_state local_file.glaze_notes "glaze notes disappeared from state"
[[ "$(tm_state_attr local_file.glaze_notes id)" == "$(tm_recall glaze_id)" ]] || tm_fail "the glaze notes were recreated"

tm_assert_no_changes
tm_pass "code, state and the kiln controller agree on 1320 °C for 40 minutes"
