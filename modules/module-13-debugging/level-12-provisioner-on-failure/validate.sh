#!/usr/bin/env bash
source "$TM_LIB"

OLD=$(tm_recall old_id)
[[ -n "$OLD" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'local-exec' "the binding run must stay a local-exec provisioner"
tm_assert_config_has 'bind\.sh' "the provisioner must still run scripts/bind.sh"
tm_assert_config_lacks 'on_failure' "failures of the binding run must not be ignored"
tm_assert_config_lacks '\|\|[[:space:]]*(true|:|exit 0)' "the command must not swallow the script's exit status"
tm_assert_config_lacks 'bind\.sh[^\n]*[0-9]C' "the script wants a plain number, not a unit"

tm_assert_in_state terraform_data.bind_batch "terraform_data.bind_batch is not in state"
NEW=$(tm_state_attr terraform_data.bind_batch id)
[[ "$NEW" != "$OLD" ]] || tm_fail "the resource was never recreated - Terraform does not rerun a provisioner on an unchanged resource"

tm_assert_file_contains bindery/batch-114.log "batch=batch-114 press=20C status=bound" \
  "bindery/batch-114.log is missing or wrong - the script has not run successfully"
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output batch "batch-114"
tm_pass "the binding run really happened and failures are no longer hidden"
