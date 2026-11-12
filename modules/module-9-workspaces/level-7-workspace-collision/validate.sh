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

tm_assert_config_has 'terraform\.workspace' "the file paths must be derived from terraform.workspace"

probe_init
probe_apply east
probe_apply west

for WS in east west; do
  FILES=$(cd "$PROBE/out" 2>/dev/null && find . -type f -path "*$WS*" | sort)
  [[ $(grep -c . <<<"$FILES") -ge 2 ]] || tm_fail "expected a bunk roster and a wake-up list for wing '$WS' (found: ${FILES:-none})"
  while IFS= read -r F; do
    F="$PROBE/out/$F"
    OTHER=$([[ "$WS" == east ]] && echo west || echo east)
    grep -q "Wing $WS" "$F" || tm_fail "$F does not describe wing $WS"
    grep -q "$OTHER" "$F" && tm_fail "$F mentions the other wing"
  done <<<"$FILES"
done

# Both wings applied: each must still be clean (no shared file being rewritten).
for WS in east west; do
  pt workspace select "$WS" >/dev/null 2>&1
  pt plan -detailed-exitcode -input=false -no-color >"$TM_LAST_OUT" 2>&1
  [[ $? -eq 0 ]] || { tm_show_last; tm_fail "wing '$WS' shows drift after both wings were applied"; }
done
tm_pass "east and west keep separate files and neither disturbs the other"
