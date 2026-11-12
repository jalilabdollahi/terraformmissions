#!/usr/bin/env bash
source "$TM_LIB"

# The defaults in variables.tf are the summer baseline; they must not be edited to fake the winter values.
grep -q 'default[[:space:]]*=[[:space:]]*70' variables.tf || tm_fail "the default target_temp_c in variables.tf must stay at the summer baseline (70)"
grep -q 'default[[:space:]]*=[[:space:]]*"manual"' variables.tf || tm_fail "the default vent_mode in variables.tf must stay 'manual'"
grep -rqE '90|"auto"|steam_per_day[[:space:]]*=[[:space:]]*6' --include='*.tf' . \
  && tm_fail "winter values must live in a variable-definitions file, not in .tf files"

# The winter values must live in a file Terraform loads automatically.
loaded=""
for f in terraform.tfvars terraform.tfvars.json *.auto.tfvars *.auto.tfvars.json; do
  [[ -f "$f" ]] && grep -q 90 "$f" && loaded="$f"
done
[[ -n "$loaded" ]] || tm_fail "no automatically loaded variable file (terraform.tfvars or *.auto.tfvars) holds the winter settings"

# Plain apply: no -var / -var-file flags.
tm_apply
tm_assert_output target_temp_c "90"
tm_assert_output vent_mode "auto"
tm_assert_output steam_per_day "6"
tm_assert_file_equals controller/settings.json '{"room":"Birch Room 3","steam":6,"temp_c":90,"vents":"auto"}'
tm_pass "winter settings loaded automatically from $loaded"
