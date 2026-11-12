#!/usr/bin/env bash
source "$TM_LIB"
terraform state replace-provider -auto-approve registry.terraform.io/-/random registry.terraform.io/hashicorp/random
terraform init
terraform plan
