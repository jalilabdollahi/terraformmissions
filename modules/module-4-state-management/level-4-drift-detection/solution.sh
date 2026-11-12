#!/usr/bin/env bash
source "$TM_LIB"
terraform plan -refresh-only
cat kiln/firing-schedule.txt
sed -i.bak 's/peak_temp_c  = 1260/peak_temp_c  = 1320/; s/hold_minutes = 25/hold_minutes = 40/' main.tf && rm -f main.tf.bak
terraform apply -auto-approve
