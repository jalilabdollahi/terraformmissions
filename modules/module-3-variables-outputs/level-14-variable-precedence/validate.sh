#!/usr/bin/env bash
source "$TM_LIB"

# The agreed values must come from terraform.tfvars, which range safety reviewed.
grep -qE '^[[:space:]]*countdown_minutes[[:space:]]*=[[:space:]]*45[[:space:]]*$' terraform.tfvars \
  || tm_fail "terraform.tfvars is the reviewed source of truth — countdown_minutes = 45 must stay there"
grep -rqE '[^0-9]45[^0-9]' --include='*.tf' . && tm_fail "the 45 must not be hard-coded in .tf files"
grep -q 'default[[:space:]]*=[[:space:]]*60' variables.tf || tm_fail "the default (60) in variables.tf must not be touched"

# No other variable file may still change the reviewed values.
for f in *.auto.tfvars *.auto.tfvars.json; do
  [[ -f "$f" ]] || continue
  grep -qE 'countdown_minutes|hold_points|pad_name' "$f" \
    && tm_fail "'$f' still sets a variable that terraform.tfvars owns — auto-loaded files are read after terraform.tfvars and win"
done

tm_apply
tm_assert_output countdown_minutes "45"
tm_assert_output pad "Pad Delta"
tm_assert_output_jq hold_points '. == [20,5]' "hold_points should be [20, 5]"
tm_assert_file_equals sheets/pad-delta.txt "Pad Delta: T-45 min countdown
Holds at: T-20, T-5
"
tm_pass "the countdown is 45 minutes, straight from the reviewed terraform.tfvars"
