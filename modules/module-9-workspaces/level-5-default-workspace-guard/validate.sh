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

tm_assert_config_has 'terraform\.workspace' "the guard must look at terraform.workspace"
tm_assert_config_has '"default"' "the guard must mention the default workspace"

probe_init
pt validate -no-color >"$TM_LAST_OUT" 2>&1 || { tm_show_last; tm_fail "the configuration does not validate"; }

# In default the plan must be refused outright.
pt workspace select default >/dev/null 2>&1
pt plan -input=false -no-color >"$TM_LAST_OUT" 2>&1
if [[ $? -eq 0 ]]; then
  tm_fail "terraform plan succeeds in the default workspace — a warning is not a guard"
fi
pt apply -auto-approve -input=false -no-color >"$TM_LAST_OUT" 2>&1
[[ $? -ne 0 ]] || tm_fail "terraform apply succeeded in the default workspace"
[[ ! -e "$PROBE/out" ]] || [[ -z "$(find "$PROBE/out" -type f 2>/dev/null)" ]] \
  || tm_fail "files were written while applying in the default workspace"

for T in fountain-a fountain-b; do
  probe_apply "$T"
  tm_assert_file_contains "$PROBE/out/$T-sprays.txt" "Fountain $T" "out/$T-sprays.txt is missing or wrong"
done
tm_pass "default is refused with an error; named fountain workspaces still apply"
