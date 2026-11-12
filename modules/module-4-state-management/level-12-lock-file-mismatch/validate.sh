#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has 'version[[:space:]]*=[[:space:]]*"~> 3\.6"' \
  "the random provider constraint '~> 3.6' must stay in terraform.tf — the lock file has to follow the code"
tm_assert_file .terraform.lock.hcl "the lock file is missing — it should be updated, not removed"

tm_init "terraform init still fails — the lock file and the version constraint disagree"

tm_assert_file_contains .terraform.lock.hcl 'provider "registry.terraform.io/hashicorp/random"' "the lock file no longer records hashicorp/random"
LOCKED=$(awk '/hashicorp\/random"/ {f=1} f && /version/ {gsub(/[" ]/,"",$3); print $3; exit}' .terraform.lock.hcl)
grep -qE '^3\.([6-9]|[1-9][0-9])\.' <<<"$LOCKED" || tm_fail "the lock file still pins random $LOCKED, which violates ~> 3.6"

tm_validate
tm_apply
tm_assert_output_jq catalog_ref 'startswith("sv-")' "output catalog_ref is missing or wrong"
tm_assert_no_changes
tm_pass "init works with random $LOCKED locked and the catalog was generated"
