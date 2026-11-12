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

tm_assert_config_lacks '"terraform\.workspace"' "a quoted \"terraform.workspace\" is just text — it is not the workspace name"
tm_assert_config_lacks 'autumn|spring' "do not hard-code a harvest name"

probe_init
for WS in autumn spring-late; do
  probe_apply "$WS"
  [[ -f "$PROBE/out/$WS-crates.txt" ]] || tm_fail "workspace '$WS' did not produce out/$WS-crates.txt (found: $(ls "$PROBE/out" 2>/dev/null | tr '\n' ' '))"
  FIRST=$(head -n 1 "$PROBE/out/$WS-crates.txt")
  [[ "$FIRST" == "Harvest: $WS" ]] || tm_fail "first line of out/$WS-crates.txt is '$FIRST', expected 'Harvest: $WS'"
  LABEL=$(pt output -raw crate_label 2>/dev/null)
  [[ "$LABEL" == "$WS-3" ]] || tm_fail "crate_label in '$WS' is '$LABEL', expected '$WS-3'"
done
[[ "$(ls "$PROBE/out" | wc -l | tr -d ' ')" == "2" ]] || tm_fail "expected exactly one manifest per workspace in out/"
tm_pass "each harvest workspace writes its own correctly named and labelled manifest"
