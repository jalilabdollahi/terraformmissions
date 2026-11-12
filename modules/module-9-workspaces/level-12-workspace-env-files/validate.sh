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

tm_assert_config_has 'terraform\.workspace' "the settings file must be chosen with terraform.workspace"
tm_assert_config_has 'yamldecode' "the YAML file must be decoded"
tm_assert_config_lacks '98\.7|91\.5|88\.1' "do not copy the settings values into the configuration"

probe_init
check_env() {  # workspace frequency power
  probe_apply "$1"
  local f p
  f=$(pt output -raw frequency 2>/dev/null); p=$(pt output -raw power_watts 2>/dev/null)
  [[ "$f" == "$2" ]] || tm_fail "workspace '$1': frequency is '$f', expected $2"
  [[ "$p" == "$3" ]] || tm_fail "workspace '$1': power_watts is '$p', expected $3"
  grep -qx "frequency_mhz=$2" "$PROBE/out/$1-transmitter.conf" || tm_fail "out/$1-transmitter.conf does not contain frequency_mhz=$2"
}
check_env dev 88.1 50
check_env staging 91.5 200
check_env prod 98.7 1000
tm_pass "dev, staging and prod each load their own settings file"
