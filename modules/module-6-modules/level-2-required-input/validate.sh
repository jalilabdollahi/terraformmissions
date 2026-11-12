#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'source[[:space:]]*=[[:space:]]*"\./modules/lockgate"' \
  "the toll must keep being computed by the lockgate module"

# The module's inputs must stay required: the fix belongs in the caller
if grep -qE 'default' modules/lockgate/main.tf 2>/dev/null; then
  tm_fail "modules/lockgate declares a default value — the caller must supply every input explicitly"
fi

tm_init
TM_MSG="terraform apply failed — read the error about the lockgate module call" tm_apply

tm_assert_in_state module.lockgate.terraform_data.toll "the toll is not computed inside module.lockgate"
tm_assert_output toll_pence 8500
tm_assert_file_equals ledger/willowbrook.txt $'toll_pence=8500\n'

# A wider boat must pay more: proves the root variable really reaches the module
tm_apply -var vessel_beam_m=6
tm_assert_output toll_pence 10500
tm_apply -var vessel_beam_m=4 -var vessel_length_m=40
tm_assert_output toll_pence 14000

tm_apply
tm_assert_no_changes
tm_pass "lockgate receives the beam and the length and the toll is 8500 pence"
