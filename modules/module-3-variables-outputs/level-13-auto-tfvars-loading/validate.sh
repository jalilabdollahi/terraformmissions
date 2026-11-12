#!/usr/bin/env bash
source "$TM_LIB"

# The defaults in variables.tf are the winter baseline; they must not be edited to fake the summer values.
grep -q 'default[[:space:]]*=[[:space:]]*18' variables.tf || tm_fail "the default target_temp_c in variables.tf must stay at the winter baseline (18)"
grep -q 'default[[:space:]]*=[[:space:]]*"manual"' variables.tf || tm_fail "the default vent_mode in variables.tf must stay 'manual'"
grep -rqE '24|"auto"|misting_per_day[[:space:]]*=[[:space:]]*6' --include='*.tf' . \
  && tm_fail "summer values must live in a variable-definitions file, not in .tf files"

# The summer values must live in a file Terraform loads automatically.
loaded=""
for f in terraform.tfvars terraform.tfvars.json *.auto.tfvars *.auto.tfvars.json; do
  [[ -f "$f" ]] && grep -q 24 "$f" && loaded="$f"
done
[[ -n "$loaded" ]] || tm_fail "no automatically loaded variable file (terraform.tfvars or *.auto.tfvars) holds the summer settings"

# Plain apply: no -var / -var-file flags.
tm_apply
tm_assert_output target_temp_c "24"
tm_assert_output vent_mode "auto"
tm_assert_output misting_per_day "6"
tm_assert_file_equals controller/settings.json '{"house":"Glasshouse 3","misting":6,"temp_c":24,"vents":"auto"}'
tm_pass "summer settings loaded automatically from $loaded"
