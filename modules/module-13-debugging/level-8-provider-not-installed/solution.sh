#!/usr/bin/env bash
source "$TM_LIB"
terraform init
terraform apply -auto-approve
