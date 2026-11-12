#!/usr/bin/env bash
source "$TM_LIB"
cat >> main.tf <<'HCL'

moved {
  from = random_id.wave_pass
  to   = random_id.day_pass
}

moved {
  from = local_file.entrance_sign
  to   = local_file.turnstile_sign
}
HCL
terraform plan
terraform apply -auto-approve
