#!/usr/bin/env bash
# Merge-request gate for the lens order sheets.
terraform fmt
terraform init
terraform validate
terraform plan
echo "pipeline done"
