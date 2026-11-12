#!/usr/bin/env bash
source "$TM_LIB"
# moves.tf (20 moved blocks) is part of the solution overlay; then apply it.
terraform apply -auto-approve
