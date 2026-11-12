#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"terraform_remote_state"' "the crew facts must be read with terraform_remote_state"
if grep -qE '160|Wilhelmina|Pike' main.tf; then tm_fail "the numbers and names must come from the remote state, not from this config"; fi

tm_apply
tm_assert_output total_seats 160
tm_assert_output head_rigger "Wilhelmina Pike"
tm_assert_file_contains box-office/season-bill.txt "Autumn season"
tm_assert_file_contains box-office/season-bill.txt "studio: 40 seats, 6 fly bars"
tm_assert_file_contains box-office/season-bill.txt "main: 120 seats, 18 fly bars"

# The crew team re-applies with different numbers and a different lead list.
trap 'terraform -chdir=stage-crew apply -auto-approve -input=false -no-color >/dev/null 2>&1' EXIT
terraform -chdir=stage-crew apply -auto-approve -input=false -no-color -var studio_seats=75 -var 'leads=["Ingrid Sol","Bram Teague","Una Pike"]' >"$TM_LAST_OUT" 2>&1 \
  || { tm_show_last; tm_fail "could not update the stage crew's state"; }
tm_apply
tm_assert_output total_seats 195
tm_assert_output head_rigger "Ingrid Sol"
tm_assert_file_contains box-office/season-bill.txt "studio: 75 seats, 6 fly bars" "the bill did not follow the crew's new outputs"
tm_pass "the season bill reads the stage crew's outputs by their real names and shapes"
