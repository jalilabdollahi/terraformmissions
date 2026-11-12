#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace select trial
terraform destroy -auto-approve
terraform workspace select default
terraform workspace delete trial
