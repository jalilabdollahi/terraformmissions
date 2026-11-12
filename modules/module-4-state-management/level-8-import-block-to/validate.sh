#!/usr/bin/env bash
source "$TM_LIB"

BERTH=$(tm_recall berth); BOARD=$(tm_recall board_id)
[[ -n "$BERTH" && -n "$BOARD" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_integer" "berth_number"' "the berth_number resource must stay in the configuration"
tm_assert_config_has 'import[[:space:]]*\{' "the adoption must be written as an import block"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*random_integer\.berth_number' \
  "no import block targets random_integer.berth_number"

tm_assert_in_state random_integer.berth_number "random_integer.berth_number is not in state — an import block only takes effect on apply"

CURRENT=$(tm_state_attr random_integer.berth_number result)
[[ "$CURRENT" == "$BERTH" ]] || tm_fail "the berth in state is $CURRENT, the quay says $BERTH — the original number was not adopted"
[[ "$(tm_state_attr random_integer.berth_number min)" == "100" && "$(tm_state_attr random_integer.berth_number max)" == "999" ]] \
  || tm_fail "the imported berth has the wrong range recorded in state"

[[ "$(tm_state_attr local_file.berth_board id)" == "$BOARD" ]] || tm_fail "the berth board was rewritten"
tm_assert_no_changes
tm_assert_file_contains harbour/berth-board.txt "berth $BERTH" "the berth board does not show berth $BERTH"
tm_pass "berth $BERTH was adopted through an import block and the plan is clean"
