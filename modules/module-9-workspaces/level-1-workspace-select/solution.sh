#!/usr/bin/env bash
source "$TM_LIB"
terraform workspace select staging
terraform apply -auto-approve
