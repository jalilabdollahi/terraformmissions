#!/usr/bin/env bash
source "$TM_LIB"

# The module is the contract; the caller has to adapt to it
tm_assert_config_has 'output[[:space:]]+"batch_id"' "the module's outputs must stay as they are"
tm_assert_config_has 'output[[:space:]]+"humidity_pct"' "the module's outputs must stay as they are"
tm_assert_config_has 'output[[:space:]]+"card_file"' "the module's outputs must stay as they are"
if grep -qE 'output[[:space:]]+"(batch_code|humidity|card_path)"' modules/cellar/main.tf 2>/dev/null; then
  tm_fail "modules/cellar must not gain alias outputs — the root has to use the module's real output names"
fi

tm_init
TM_MSG="terraform apply failed — the error lists which module attribute does not exist" tm_apply

tm_assert_in_state module.cellar.local_file.tray_card "the tray card is not managed inside module.cellar"
tm_assert_output batch "SHI-W14"
tm_assert_output humidity 78
tm_assert_output card "./cards/shiitake.txt"
tm_assert_file_equals cards/shiitake.txt $'SHI-W14 @ 78% RH\n'

tm_apply -var species=oyster -var week=3
tm_assert_output batch "OYS-W3"
tm_assert_output humidity 85
tm_assert_file_equals cards/oyster.txt $'OYS-W3 @ 85% RH\n'

tm_apply
tm_assert_no_changes
tm_pass "the root reads batch_id, humidity_pct and card_file from module.cellar"
