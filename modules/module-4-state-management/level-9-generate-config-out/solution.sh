#!/usr/bin/env bash
source "$TM_LIB"
# Normally: terraform plan -generate-config-out=generated.tf, then merge it into main.tf and tidy it.
# The finished main.tf is supplied by the solution overlay; this performs the import.
terraform apply -auto-approve
