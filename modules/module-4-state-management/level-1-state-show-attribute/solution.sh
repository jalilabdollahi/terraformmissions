#!/usr/bin/env bash
source "$TM_LIB"
mkdir -p answers
terraform state list
terraform state show -no-color 'random_integer.serial["annex"]' | awk '$1 == "result" { print $3 }' > answers/vault-serial.txt
terraform state show -no-color random_pet.night_guard | awk '$1 == "id" { gsub(/"/, "", $3); print $3 }' > answers/night-guard.txt
