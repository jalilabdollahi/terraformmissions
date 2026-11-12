#!/usr/bin/env bash
source "$TM_LIB"

OLD=$(tm_recall old_id)
[[ -n "$OLD" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'local-exec' "the developing run must stay a local-exec provisioner"
tm_assert_config_has 'develop\.sh' "the provisioner must still run scripts/develop.sh"
tm_assert_config_lacks 'on_failure' "failures of the developing run must not be ignored"
tm_assert_config_lacks '\|\|[[:space:]]*(true|:|exit 0)' "the command must not swallow the script's exit status"
tm_assert_config_lacks 'develop\.sh[^\n]*[0-9]C' "the script wants a plain number, not a unit"

tm_assert_in_state terraform_data.develop_batch "terraform_data.develop_batch is not in state"
NEW=$(tm_state_attr terraform_data.develop_batch id)
[[ "$NEW" != "$OLD" ]] || tm_fail "the resource was never recreated - Terraform does not rerun a provisioner on an unchanged resource"

tm_assert_file_contains darkroom/batch-114.log "batch=batch-114 bath=20C status=developed" \
  "darkroom/batch-114.log is missing or wrong - the script has not run successfully"
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output batch "batch-114"
tm_pass "the developing run really happened and failures are no longer hidden"
