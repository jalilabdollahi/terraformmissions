#!/usr/bin/env bash
source "$TM_LIB"
ls -l terraform.tfstate terraform.tfstate.backup
cp terraform.tfstate.backup terraform.tfstate
terraform plan
