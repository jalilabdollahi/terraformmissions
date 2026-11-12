#!/usr/bin/env bash
source "$TM_LIB"
terraform init -migrate-state -force-copy
terraform plan
