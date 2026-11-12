#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'provider::terraform::encode_tfvars[[:space:]]*\(' "write the file with the provider function encode_tfvars"
tm_assert_config_has 'provider::terraform::decode_tfvars[[:space:]]*\(' "read last month's settings with decode_tfvars"
tm_assert_config_has 'terraform\.io/builtin/terraform' "the built-in terraform provider has to be declared in required_providers"

tm_validate "the configuration does not validate"
tm_apply

EXPECT='limits = {
  minutes     = 4
  per_thrower = 2
}
open    = true
room    = "Blue Note"
seats   = 24
targets = ["Bullseye", "Skull Board"]'
[[ "$(cat stack/night.tfvars 2>/dev/null)" == "$EXPECT" ]] || {
  echo "   stack/night.tfvars contains:"; sed 's/^/   │ /' stack/night.tfvars 2>/dev/null
  tm_fail "stack/night.tfvars is not the encode_tfvars rendering of the venue object (keys sorted, nested objects expanded)"
}
tm_assert_output seat_growth 8
tm_assert_no_changes
tm_pass "the tfvars file is generated and parsed with the built-in provider functions"
