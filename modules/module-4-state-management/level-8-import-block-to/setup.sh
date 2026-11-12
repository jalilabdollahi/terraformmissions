#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
N=$(tm_state_attr random_integer.room_number result)
tm_record room "$N"
tm_record board_id "$(tm_state_attr local_file.room_board id)"
mkdir -p halls
cat > halls/room-sheet.txt <<NOTE
Halls office, room allocation sheet
  First-year student .... room ${N}
  Allocation pool ....... 100 to 999
NOTE
# The earlier state is lost: only the room number is forgotten.
terraform state rm random_integer.room_number >/dev/null
# Ilse's attempt at an import block: wrong target name and wrong range in the ID.
cat > imports.tf <<HCL
import {
  to = random_integer.room_no
  id = "${N},1,999"
}
HCL
