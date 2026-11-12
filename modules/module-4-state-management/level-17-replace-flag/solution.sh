#!/usr/bin/env bash
source "$TM_LIB"
terraform apply -auto-approve -replace='random_integer.door_code["booth"]'
