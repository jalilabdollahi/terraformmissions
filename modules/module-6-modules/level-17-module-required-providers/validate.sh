#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'version[[:space:]]*=[[:space:]]*"~>[[:space:]]*2\.5"' "the root must keep requiring hashicorp/local ~> 2.5"
tm_assert_config_has 'source[[:space:]]*=[[:space:]]*"hashicorp/local"' "the module has to keep declaring the local provider"

tm_init "terraform init failed — read which constraints it says cannot be satisfied together"
chosen=$(terraform version -json 2>/dev/null | jq -r '.provider_selections["registry.terraform.io/hashicorp/local"] // empty')
[[ "$chosen" == 2.* ]] || tm_fail "the local provider resolved to '$chosen', not a 2.x release"
if ! grep -rE 'required_providers' modules/kitchen >/dev/null 2>&1; then
  tm_fail "modules/kitchen no longer declares which providers it needs"
fi

tm_apply
tm_assert_in_state module.kitchen.local_file.supper
tm_assert_output courses 3
tm_assert_file_equals menu/supper.txt $'1. smoked salmon\n2. reindeer stew\n3. cloudberry cream'

tm_apply -var 'dishes=["fish soup","lefse"]'
tm_assert_output courses 2
tm_assert_file_equals menu/supper.txt $'1. fish soup\n2. lefse'

tm_apply
tm_assert_no_changes
tm_pass "root and kitchen agree on a local provider 2.x"
