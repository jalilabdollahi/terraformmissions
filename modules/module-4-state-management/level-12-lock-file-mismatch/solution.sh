#!/usr/bin/env bash
source "$TM_LIB"
terraform init -upgrade
terraform apply -auto-approve
