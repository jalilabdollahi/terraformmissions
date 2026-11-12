#!/usr/bin/env bash
source "$TM_LIB"
# terraform.tf is fixed by the solution overlay: path = "states/tuktuk-prod.tfstate"
terraform init -reconfigure
terraform plan
