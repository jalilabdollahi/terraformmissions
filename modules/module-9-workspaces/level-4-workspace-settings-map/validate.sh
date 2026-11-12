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

tm_assert_config_has 'local\.layouts\[terraform\.workspace\]|lookup\(local\.layouts' "the layout must still be looked up with terraform.workspace"

check_ws() {  # workspace stalls hours music
  probe_apply "$1"
  local s h m
  s=$(pt output -raw stalls 2>/dev/null); h=$(pt output -raw hours 2>/dev/null)
  [[ "$s" == "$2" ]] || tm_fail "in workspace '$1' stalls is '$s', expected $2"
  [[ "$h" == "$3" ]] || tm_fail "in workspace '$1' hours is '$h', expected $3"
  grep -qx "music=$4" "$PROBE/out/$1-board.txt" || tm_fail "out/$1-board.txt should contain music=$4"
}

probe_init
check_ws qa 12 09-16 false
check_ws dev 4 10-14 false
check_ws prod 24 08-18 true

# The player's own selected workspace (qa after setup) must also plan cleanly.
tm_plan_ok
tm_pass "qa, dev and prod each get their own stall layout"
