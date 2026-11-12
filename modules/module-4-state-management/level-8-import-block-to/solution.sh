#!/usr/bin/env bash
source "$TM_LIB"
N=$(awk '/First-year/ { print $NF }' halls/room-sheet.txt)
cat > imports.tf <<HCL
import {
  to = random_integer.room_number
  id = "${N},100,999"
}
HCL
terraform plan
terraform apply -auto-approve
