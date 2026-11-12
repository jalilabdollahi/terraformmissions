#!/usr/bin/env bash
source "$TM_LIB"
LIST=$(terraform workspace list 2>/dev/null | sed 's/^[ *]*//')
grep -qx 'keep' <<<"$LIST" || tm_fail "the keep workspace is gone — only trial should be deleted"
grep -qx 'trial' <<<"$LIST" && tm_fail "the trial workspace still exists"
[[ ! -d terraform.tfstate.d/trial ]] || tm_fail "terraform.tfstate.d/trial is still on disk"

[[ ! -e out/trial-batch.txt ]] || tm_fail "out/trial-batch.txt is still on disk — the trial resources were abandoned, not destroyed"

tm_assert_config_has 'terraform\.workspace' "the batch file name must keep using terraform.workspace"
CUR=$(terraform workspace show 2>/dev/null)
[[ "$CUR" != "trial" ]] || tm_fail "the trial workspace is still selected"

KEEP=terraform.tfstate.d/keep/terraform.tfstate
[[ "$(jq '[.resources[]?] | length' "$KEEP" 2>/dev/null)" == "1" ]] || tm_fail "the keep workspace lost its resource"
tm_assert_file_contains out/keep-batch.txt "akadama 60" "out/keep-batch.txt was changed or removed"
terraform workspace select keep >/dev/null 2>&1 || tm_fail "could not inspect keep"
CODE=$(tm_plan_code)
terraform workspace select "$CUR" >/dev/null 2>&1
[[ "$CODE" == "0" ]] || tm_fail "the keep workspace no longer has a clean plan"
tm_pass "trial is deleted after being destroyed; keep is intact and clean"
