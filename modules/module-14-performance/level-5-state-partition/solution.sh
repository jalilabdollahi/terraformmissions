#!/usr/bin/env bash
source "$TM_LIB"
terraform -chdir=core init -input=false
terraform state mv -state-out=core/terraform.tfstate random_pet.yard_name random_pet.yard_name
terraform state mv -state-out=core/terraform.tfstate random_integer.gate_count random_integer.gate_count
terraform -chdir=core apply -auto-approve
terraform apply -auto-approve
