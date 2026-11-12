#!/usr/bin/env bash
source "$TM_LIB"

tm_init "terraform init still fails — Terraform cannot find the provider at the address given"
tm_assert_config_has 'required_providers' "keep the required_providers block"
tm_assert_config_has '"hashicorp/local"' "the local provider should be sourced from its real address"
tm_assert_config_lacks 'hashicorp/localfile' "hashicorp/localfile is not a real provider"
tm_validate
tm_apply
tm_assert_file_contains apiary/inspection.txt "clover-row: ~48000 bees"
tm_assert_file_contains apiary/inspection.txt "heather-row: ~36500 bees"
tm_assert_output total_bees 84500
# The provider that ended up in the lock file must be the real hashicorp/local
grep -q 'registry.terraform.io/hashicorp/local"' .terraform.lock.hcl 2>/dev/null \
  || tm_fail "the lock file does not record registry.terraform.io/hashicorp/local"
tm_assert_no_changes
tm_pass "the provider resolves to hashicorp/local and the inspection log is written"
