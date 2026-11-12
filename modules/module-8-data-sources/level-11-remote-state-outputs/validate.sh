#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"terraform_remote_state"' "the staff facts must be read with terraform_remote_state"
if grep -qE '160|Wilhelmina|Pike' main.tf; then tm_fail "the numbers and names must come from the remote state, not from this config"; fi

tm_apply
tm_assert_output total_couples 160
tm_assert_output head_caller "Wilhelmina Pike"
tm_assert_file_contains front-desk/season-programme.txt "Autumn season"
tm_assert_file_contains front-desk/season-programme.txt "studio: 40 couples, 6 mirrors"
tm_assert_file_contains front-desk/season-programme.txt "grand: 120 couples, 18 mirrors"

# The staff team re-applies with different numbers and a different lead list.
trap 'terraform -chdir=floor-staff apply -auto-approve -input=false -no-color >/dev/null 2>&1' EXIT
terraform -chdir=floor-staff apply -auto-approve -input=false -no-color -var studio_couples=75 -var 'leads=["Ingrid Sol","Bram Teague","Una Pike"]' >"$TM_LAST_OUT" 2>&1 \
  || { tm_show_last; tm_fail "could not update the floor staff's state"; }
tm_apply
tm_assert_output total_couples 195
tm_assert_output head_caller "Ingrid Sol"
tm_assert_file_contains front-desk/season-programme.txt "studio: 75 couples, 6 mirrors" "the programme did not follow the staff's new outputs"
tm_pass "the season programme reads the floor staff's outputs by their real names and shapes"
