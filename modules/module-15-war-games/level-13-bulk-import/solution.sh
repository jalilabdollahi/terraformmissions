#!/usr/bin/env bash
source "$TM_LIB"
# solution/main.tf (filtered for_each, computed byte_length, import block with for_each) is overlaid.
terraform plan
terraform apply -auto-approve
