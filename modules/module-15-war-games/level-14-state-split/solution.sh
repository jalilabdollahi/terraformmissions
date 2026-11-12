#!/usr/bin/env bash
source "$TM_LIB"
# monolith/*.tf is removed and krewes gains its gold_series output through the solution overlay.
SRC="$WORKSPACE/monolith/terraform.tfstate"
move() { # <stack> <old address> <new address>
  terraform state mv -state="$SRC" -state-out="$WORKSPACE/$1/terraform.tfstate" "$2" "$3" || exit 1
}
cd "$WORKSPACE" || exit 1
move warehouse random_id.dock_key random_id.dock_key
move warehouse random_integer.rider_capacity random_integer.rider_capacity
move warehouse random_id.float_serial random_id.float_serial
move krewes random_uuid.signup_ns random_uuid.signup_ns
move krewes random_integer.bead_series random_integer.bead_series
move krewes local_file.bead_ledger local_file.bead_ledger
move lighting random_id.rig_key random_id.light_key
move lighting terraform_data.controller terraform_data.controller
move lighting local_file.cue_sheet local_file.cue_sheet
for d in warehouse krewes lighting; do
  (cd "$WORKSPACE/$d" && terraform apply -auto-approve) || exit 1
done
