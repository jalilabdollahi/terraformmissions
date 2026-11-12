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

tm_assert_config_has 'terraform\.workspace' "the decision must come from terraform.workspace"
tm_assert_config_lacks '"prd"' "the production check still uses the abbreviation"

probe_init
probe_apply prod
R=$(pt output -raw retention_days 2>/dev/null)
[[ "$R" == "90" ]] || tm_fail "in the prod workspace retention_days is '$R', expected 90"
P=$(pt output -raw pager_enabled 2>/dev/null)
[[ "$P" == "true" ]] || tm_fail "in the prod workspace pager_enabled is '$P', expected true"
[[ -f "$PROBE/out/pager-roster.txt" ]] || tm_fail "prod did not create out/pager-roster.txt"
tm_assert_file_contains "$PROBE/out/prod-tank-log.txt" "retention_days=90" "prod tank log has the wrong retention"

for WS in dev staging; do
  probe_apply "$WS"
  R=$(pt output -raw retention_days 2>/dev/null)
  [[ "$R" == "7" ]] || tm_fail "in the $WS workspace retention_days is '$R', expected 7 — only prod gets 90"
  P=$(pt output -raw pager_enabled 2>/dev/null)
  [[ "$P" == "false" ]] || tm_fail "in the $WS workspace pager_enabled is '$P', expected false"
  pt state list >"$TM_LAST_OUT" 2>&1
  grep -q 'pager_roster' "$TM_LAST_OUT" && tm_fail "workspace $WS has a pager roster in its state"
done
tm_pass "prod gets 90-day retention and a pager roster; dev and staging stay at 7 days without one"
