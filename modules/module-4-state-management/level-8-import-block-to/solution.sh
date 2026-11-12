#!/usr/bin/env bash
source "$TM_LIB"
N=$(awk '/Cargo vessel/ { print $NF }' harbour/berth-sheet.txt)
cat > imports.tf <<HCL
import {
  to = random_integer.berth_number
  id = "${N},100,999"
}
HCL
terraform plan
terraform apply -auto-approve
