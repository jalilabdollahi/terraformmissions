#!/usr/bin/env bash
source "$TM_LIB"
terraform apply -auto-approve -replace=terraform_data.bind_batch
