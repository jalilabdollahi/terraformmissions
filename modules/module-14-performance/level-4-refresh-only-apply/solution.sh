#!/usr/bin/env bash
source "$TM_LIB"
terraform plan -refresh-only
terraform apply -refresh-only -auto-approve
