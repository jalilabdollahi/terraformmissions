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

tm_assert_config_has 'terraform\.workspace' "station lists must still be chosen by terraform.workspace"
tm_assert_config_has 'for_each' "the perch cards must still be created with for_each"
tm_assert_config_lacks '[[:space:]]count[[:space:]]*=' "use for_each, not count"

probe_init
expect_ws() {  # workspace expected-count slugs...
  local ws="$1" n="$2"; shift 2
  probe_apply "$ws"
  local list got slug
  list=$(pt state list 2>/dev/null | grep '^local_file.perch\[' | sort)
  [[ $(grep -c . <<<"$list") == "$n" ]] || tm_fail "workspace '$ws' should have $n perch instances, state has: $(tr '\n' ' ' <<<"$list")"
  for slug in "$@"; do
    grep -qxF "local_file.perch[\"$slug\"]" <<<"$list" || tm_fail "workspace '$ws' is missing local_file.perch[\"$slug\"]"
    [[ -f "$PROBE/out/$ws/$slug.txt" ]] || tm_fail "workspace '$ws' is missing out/$ws/$slug.txt"
  done
  got=$(pt output -raw station_count 2>/dev/null)
  [[ "$got" == "$n" ]] || tm_fail "station_count in '$ws' is '$got', expected $n"
}
expect_ws pilot 2 elm-hill dovecote
expect_ws network 4 elm-hill dovecote mill-pond ash-cross
tm_pass "pilot gets two perch cards, network gets four, each keyed by station"
