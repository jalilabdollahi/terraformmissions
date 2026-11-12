#!/usr/bin/env bash
source "$TM_LIB"
# The corrected quota ranges in all-in-one/main.tf and the deleted team code come with the solution overlay.
cd "$WORKSPACE" || exit 1
DEST="$WORKSPACE/stacks/all-in-one/terraform.tfstate"
move() { # <source state file> <team>
  for r in random_id.batch random_integer.quota local_file.ledger; do
    terraform state mv -state="$1" -state-out="$DEST" "$r" "module.$2.$r" || exit 1
  done
}
move "$WORKSPACE/stacks/orchard/terraform.tfstate" orchard
move "$WORKSPACE/stacks/press/terraform.tfstate" press
move "$WORKSPACE/stacks/cellar/terraform.tfstate.d/autumn/terraform.tfstate" cellar
cd "$WORKSPACE/stacks/all-in-one" || exit 1
terraform plan
terraform apply -auto-approve
