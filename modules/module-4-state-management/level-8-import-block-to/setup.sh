#!/usr/bin/env bash
source "$TM_LIB"
tm_apply
N=$(tm_state_attr random_integer.berth_number result)
tm_record berth "$N"
tm_record board_id "$(tm_state_attr local_file.berth_board id)"
mkdir -p harbour
cat > harbour/berth-sheet.txt <<NOTE
Harbour office, berth allocation sheet
  Cargo vessel .......... berth ${N}
  Allocation pool ....... 100 to 999
NOTE
# The earlier state is lost: only the berth number is forgotten.
terraform state rm random_integer.berth_number >/dev/null
# Ilse's attempt at an import block: wrong target name and wrong range in the ID.
cat > imports.tf <<HCL
import {
  to = random_integer.berth_no
  id = "${N},1,999"
}
HCL
