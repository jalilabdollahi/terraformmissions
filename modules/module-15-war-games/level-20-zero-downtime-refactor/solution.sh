#!/usr/bin/env bash
source "$TM_LIB"
# moves.tf (nine moved blocks and one removed block) comes with the solution overlay.
terraform apply -auto-approve
