#!/usr/bin/env bash
source "$TM_LIB"

OLD=$(tm_recall old_id)
[[ -n "$OLD" ]] || tm_fail "mission state is missing - run 'reset' to restore the level"

tm_assert_config_has 'local-exec' "the flash must still run through the local-exec provisioner"
tm_assert_config_lacks 'on_failure' "do not tell Terraform to ignore a failing flash"
tm_assert_config_lacks 'ignore_changes' "the object must be recreated, not ignored"

tm_assert_in_state terraform_data.sprayer_firmware "terraform_data.sprayer_firmware is not in state"
SHOW=$(terraform state show terraform_data.sprayer_firmware 2>&1)
[[ "$SHOW" != *tainted* ]] || tm_fail "terraform_data.sprayer_firmware is still tainted - it has not been recreated yet"

NEW=$(tm_state_attr terraform_data.sprayer_firmware id)
[[ "$NEW" != "$OLD" ]] || tm_fail "the sprayer controller object still has its old ID - the tainted instance was never replaced"

tm_assert_file_contains flashed/van-07.stamp "van=van-07 firmware=4.2.1" \
  "flashed/van-07.stamp is missing or wrong - the provisioner has not completed successfully"
tm_assert_no_changes
tm_assert_no_changes
tm_assert_output firmware_target "4.2.1"
tm_pass "the tainted sprayer flash was replaced by a successful provisioner run"
