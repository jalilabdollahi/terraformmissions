#!/usr/bin/env bash
source "$TM_LIB"
terraform state mv random_pet.keeper random_pet.night_keeper
terraform apply -auto-approve
