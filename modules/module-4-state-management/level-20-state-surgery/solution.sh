#!/usr/bin/env bash
source "$TM_LIB"
SILO=$(awk '/Silo number/ { print $NF }' plates/silo-plate.txt)
terraform state mv random_pet.harvester random_pet.combine_operator
terraform import random_integer.silo_number "${SILO},100,999"
terraform state rm local_file.retired_gauge_log
terraform plan
