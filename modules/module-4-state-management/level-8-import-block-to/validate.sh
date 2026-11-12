#!/usr/bin/env bash
source "$TM_LIB"

ROOM=$(tm_recall room); BOARD=$(tm_recall board_id)
[[ -n "$ROOM" && -n "$BOARD" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_has 'resource "random_integer" "room_number"' "the room_number resource must stay in the configuration"
tm_assert_config_has 'import[[:space:]]*\{' "the adoption must be written as an import block"
tm_assert_config_has 'to[[:space:]]*=[[:space:]]*random_integer\.room_number' \
  "no import block targets random_integer.room_number"

tm_assert_in_state random_integer.room_number "random_integer.room_number is not in state — an import block only takes effect on apply"

CURRENT=$(tm_state_attr random_integer.room_number result)
[[ "$CURRENT" == "$ROOM" ]] || tm_fail "the room in state is $CURRENT, the door says $ROOM — the original number was not adopted"
[[ "$(tm_state_attr random_integer.room_number min)" == "100" && "$(tm_state_attr random_integer.room_number max)" == "999" ]] \
  || tm_fail "the imported room has the wrong range recorded in state"

[[ "$(tm_state_attr local_file.room_board id)" == "$BOARD" ]] || tm_fail "the room board was rewritten"
tm_assert_no_changes
tm_assert_file_contains halls/room-board.txt "room $ROOM" "the room board does not show room $ROOM"
tm_pass "room $ROOM was adopted through an import block and the plan is clean"
