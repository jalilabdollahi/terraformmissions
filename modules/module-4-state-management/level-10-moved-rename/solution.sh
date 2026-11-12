#!/usr/bin/env bash
source "$TM_LIB"
cat >> main.tf <<'HCL'

moved {
  from = random_id.zip_pass
  to   = random_id.climb_pass
}

moved {
  from = local_file.gate_sign
  to   = local_file.harness_sign
}
HCL
terraform plan
terraform apply -auto-approve
