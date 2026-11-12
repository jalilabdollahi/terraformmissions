#!/usr/bin/env bash
source "$TM_LIB"
mv terraform.tfstate.d/winter.tfstate terraform.tfstate.d/winter/terraform.tfstate
terraform plan
