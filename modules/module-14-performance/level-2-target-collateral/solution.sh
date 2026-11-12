#!/usr/bin/env bash
source "$TM_LIB"
terraform plan
terraform apply -auto-approve
