#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_config_has '^[[:space:]]*lifecycle[[:space:]]*\{' "lifecycle must be written as a nested block: lifecycle { ... }"
tm_assert_config_has '^[[:space:]]*required_providers[[:space:]]*\{' "required_providers must be a nested block: required_providers { ... }"
tm_init "terraform init failed"
tm_validate "terraform still rejects a block that was written like an attribute"
tm_assert_config_has 'ignore_changes' "keep the ignore_changes setting"
tm_apply
tm_assert_file_equals vault/label-BEAN-2031.txt $'Seed lot: BEAN-2031\nLast inspected by: M. Okafor\n'
code=$(tm_plan_code -var 'inspector=T. Lindqvist')
[[ "$code" == "0" ]] || { tm_show_last; tm_fail "changing the inspector still wants to rewrite the label (plan exit $code) — the lifecycle setting is not in effect"; }
tm_assert_no_changes
tm_pass "blocks are written as blocks and inspector changes no longer touch the label"
