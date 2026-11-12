#!/usr/bin/env bash
source "$TM_LIB"
PROBE="$TM_TMP/probe"
pt() { terraform -chdir="$PROBE" "$@"; }

# Scratch copy of the player's config: the real workspaces and state are never touched.
probe_init() {
  rm -rf "$PROBE"; mkdir -p "$PROBE"
  tar -cf - --exclude=.terraform --exclude=terraform.tfstate.d --exclude=.tm . | (cd "$PROBE" && tar -xf -)
  rm -rf "$PROBE/out" "$PROBE"/terraform.tfstate*
  pt init -input=false -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "terraform init failed on a scratch copy of the configuration"; }
}

# probe_apply <workspace>: create/select the workspace in the scratch copy and apply.
probe_apply() {
  pt workspace new "$1" >"$TM_LAST_OUT" 2>&1 || pt workspace select "$1" >"$TM_LAST_OUT" 2>&1
  if ! pt apply -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1; then
    tm_show_last
    tm_fail "apply failed in workspace '$1'"
  fi
}

tm_assert_config_has 'terraform\.workspace' "the lane count must still depend on terraform.workspace"
tm_assert_config_has 'var\.lane_count >= 1' "the module's validation must stay in place"

probe_init
expect_lanes() {  # workspace count
  probe_apply "$1"
  local n files
  n=$(pt output -json lane_files 2>/dev/null | jq 'length' 2>/dev/null)
  [[ "$n" == "$2" ]] || tm_fail "workspace '$1' should have $2 lane(s), the lane_files output has '$n'"
  files=$(cd "$PROBE/out" && ls | grep -c "^$1-lane-")
  [[ "$files" == "$2" ]] || tm_fail "workspace '$1' should have written $2 lane file(s), found $files"
}
expect_lanes prod 4
expect_lanes staging 2
expect_lanes pr-142 1
expect_lanes hotfix-7 1

tm_plan_ok
tm_pass "prod gets 4 lanes, staging 2, and any other workspace 1"
