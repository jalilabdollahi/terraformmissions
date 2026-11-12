#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'data[[:space:]]+"terraform_remote_state"' "the depot facts must be read with terraform_remote_state"
if grep -qE 'NRT-04|05:12' main.tf; then tm_fail "the depot facts must come from the remote state, not from this config"; fi
grep -q 'state/depot.tfstate' depot-team/terraform.tf 2>/dev/null \
  || tm_fail "the depot team's backend settings must stay as they are"

tm_apply
tm_assert_output depot_code "NRT-04"
tm_assert_file_equals timetable/header.txt "Depot NRT-04: 6 tracks, first tram 05:12
"

# The link must be live: change the depot team's published output and re-apply.
trap 'terraform -chdir=depot-team apply -auto-approve -input=false -no-color >/dev/null 2>&1' EXIT
terraform -chdir=depot-team apply -auto-approve -input=false -no-color -var track_count=9 >"$TM_LAST_OUT" 2>&1 \
  || { tm_show_last; tm_fail "could not update the depot team's state"; }
tm_apply
tm_assert_file_contains timetable/header.txt "9 tracks, first tram 05:12" "the header did not follow the depot team's new output"
tm_pass "the timetable header is read live from the depot team's state"
