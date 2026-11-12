#!/usr/bin/env bash
source "$TM_LIB"

VENDOR=$(tm_recall vendor)
[[ -n "$VENDOR" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_file .terraform.lock.hcl ".terraform.lock.hcl is missing"
tm_assert_config_has 'version[[:space:]]*=[[:space:]]*"3.3.2"' "the null provider must stay pinned to 3.3.2"

now=$(find vendor -type f -exec shasum {} \; | sort | shasum | cut -d' ' -f1)
[[ "$now" == "$VENDOR" ]] || tm_fail "the vendored mirror in vendor/ was modified"

# What the lock file should contain: ask Terraform itself, offline, in a scratch copy.
SCR="$TM_TMP/lockcheck"
mkdir -p "$SCR"
cp terraform.tf "$SCR/"
cp -R vendor "$SCR/vendor"
(cd "$SCR" && terraform providers lock -fs-mirror=vendor/provider-mirror \
   -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64 -no-color >"$TM_LAST_OUT" 2>&1) \
  || { tm_show_last; tm_fail "could not compute the expected checksums from vendor/provider-mirror"; }
expected=$(grep -o '"h1:[^"]*"' "$SCR/.terraform.lock.hcl")
[[ "$(grep -c . <<<"$expected")" == "3" ]] || tm_fail "internal: expected three platform checksums"

actual=$(grep -o '"h1:[^"]*"' .terraform.lock.hcl)
total=$(grep -c . <<<"$actual")
while IFS= read -r h; do
  grep -qF -- "$h" <<<"$actual" || tm_fail "the lock file is missing a checksum that the vendored mirror provides for another platform ($h)"
done <<<"$expected"
[[ "$total" -ge 4 ]] || tm_fail "the lock file holds $total checksum(s); it needs the local platform plus three more"
grep -q 'version[[:space:]]*=[[:space:]]*"3.3.2"' .terraform.lock.hcl || tm_fail "the lock file does not pin null 3.3.2"

# And it still works here.
tm_init "terraform init no longer succeeds with this lock file (the checksum for this machine must stay)"
tm_assert_no_file terraform.tfstate "no state expected"
tm_pass "lock file carries $total checksums: this machine plus linux_amd64, darwin_arm64, windows_amd64"
