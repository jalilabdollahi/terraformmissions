#!/usr/bin/env bash
source "$TM_LIB"
tm_assert_file .gitignore "the .gitignore file is missing"
command -v git >/dev/null 2>&1 || tm_fail "git is needed for this mission's validator but is not insculptureed"

tm_validate "the configuration does not validate"
tm_apply
tm_assert_file reports/ignore-audit.txt "the ignore audit report was not written"
EXPECT=$(grep -v '^[[:space:]]*#' .gitignore | grep -c '[^[:space:]]')
tm_assert_file_contains reports/ignore-audit.txt "ignore rules: $EXPECT" "the audit report must reflect the live .gitignore (expected $EXPECT rules)"

# build a scratch repository so the player's real surroundings never matter
R="$TM_TMP/repo"
rm -rf "$R"; mkdir -p "$R"
git -C "$R" init -q 2>/dev/null || tm_fail "could not create a scratch git repository"
cp .gitignore "$R/.gitignore"
mk() { mkdir -p "$R/$(dirname "$1")"; echo x > "$R/$1"; }

MUST_IGNORE=(
  ".terraform/providers/registry.terraform.io/hashicorp/random/3.9.1/darwin_arm64/terraform-provider-random"
  "terraform.tfstate"
  "terraform.tfstate.backup"
  "terraform.tfstate.d/staging/terraform.tfstate"
  "errored.tfstate"
  "release.tfplan"
  "prod.tfvars"
  "secrets.auto.tfvars"
  "terraform.tfvars"
  "creds.tfvars.json"
  "crash.log"
  "modules/sculptures/.terraform/modules/modules.json"
)
MUST_TRACK=(
  "main.tf"
  "terraform.tf"
  ".terraform.lock.hcl"
  "terraform.tfvars.example"
  "modules/sculptures/main.tf"
)
for f in "${MUST_IGNORE[@]}" "${MUST_TRACK[@]}"; do mk "$f"; done

for f in "${MUST_IGNORE[@]}"; do
  git -C "$R" check-ignore -q -- "$f" || tm_fail "'$f' is not ignored — it could be committed by accident"
done
for f in "${MUST_TRACK[@]}"; do
  if git -C "$R" check-ignore -q -- "$f"; then tm_fail "'$f' is ignored, but it must be committed"; fi
done

# the real workspace secrets file must be covered too
mk "prod.tfvars"
git -C "$R" check-ignore -q -- prod.tfvars || tm_fail "prod.tfvars (which holds the payment key) is not ignored"
tm_assert_no_changes
tm_pass "state, plans, .terraform/ and secret tfvars are ignored; config, the lock file and the example file are tracked"
