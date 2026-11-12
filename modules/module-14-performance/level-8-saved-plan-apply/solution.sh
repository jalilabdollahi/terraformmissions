#!/usr/bin/env bash
source "$TM_LIB"
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
