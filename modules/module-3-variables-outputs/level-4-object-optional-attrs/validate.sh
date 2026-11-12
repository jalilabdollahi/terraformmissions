#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'optional\(' "the missing attribute should be declared optional with a default"
tm_assert_file terraform.tfvars "terraform.tfvars should still exist — the menu data is the input, keep it"
tm_assert_config_has 'vanilla' "the vanilla entry must stay in the menu data"
tm_assert_config_has 'salted caramel' "the salted caramel entry must stay in the menu data"

tm_apply
tm_assert_output_jq menu 'length == 4' "the menu must still have 4 flavours"
tm_assert_output_jq menu 'map(select(.name=="vanilla"))[0].size == "regular"' "vanilla should default to size 'regular'"
tm_assert_output_jq menu 'map(select(.name=="salted caramel"))[0].size == "regular"' "salted caramel should default to size 'regular'"
tm_assert_output_jq menu 'map(select(.name=="mango sorbet"))[0].size == "large"' "an explicit size must be kept (mango sorbet is large)"
[[ "$(jq -r '.items | map(.size) | map(select(. == null)) | length' till/menu.json)" == "0" ]] \
  || tm_fail "till/menu.json contains entries without a size"

# The default must live in the type, not in the data: a brand-new entry with no size also gets one.
tm_plan_json -var 'flavours=[{name="stracciatella",price=4.9}]'
[[ "$(jq -r '.planned_values.outputs.menu.value[0].size' "$TM_TMP/plan.json")" == "regular" ]] \
  || tm_fail "an entry passed without 'size' did not receive the default — declare the default in the variable's type"
tm_pass "size is optional with a default of 'regular' for every entry"
