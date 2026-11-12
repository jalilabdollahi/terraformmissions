#!/usr/bin/env bash
# TerraformMissions — shared validator library.
#
# Every level's validate.sh (and optional setup.sh) starts with:
#
#   #!/usr/bin/env bash
#   source "$TM_LIB"
#
# NOTE: tm_fail/tm_pass call `exit`, so never call them inside $( ... ) —
# that only exits the subshell.
#
# Sourcing this file enables `set -uo pipefail` but deliberately NOT `set -e`:
# terraform uses non-zero exit codes for non-error outcomes (plan
# -detailed-exitcode returns 2 when changes are pending), so scripts must
# inspect exit codes explicitly. Use the helpers below; they never abort the
# script on their own.
#
# Environment provided by the engine / test harness:
#   WORKSPACE   absolute path of the player's workspace (also the cwd)
#   LEVEL_PATH  absolute path of the level directory (modules/.../level-N-x)
#   TM_LIB      absolute path of this file
#   TM_TMP      private scratch dir for this run (deleted afterwards)

set -uo pipefail

: "${WORKSPACE:=$PWD}"
: "${TM_TMP:=$(mktemp -d)}"
export TF_IN_AUTOMATION=1
export TF_INPUT=0

cd "$WORKSPACE" || { echo "❌ FAIL: workspace not found: $WORKSPACE"; exit 1; }

TM_LAST_OUT="$TM_TMP/last_output.txt"

# ── Result helpers ────────────────────────────────────────────────────────────

tm_pass() { echo "✅ PASS: $*"; exit 0; }
tm_fail() { echo "❌ FAIL: $*"; exit 1; }
tm_info() { echo "   • $*"; }

# Print the captured output of the last terraform command (indented).
tm_show_last() { [[ -s "$TM_LAST_OUT" ]] && sed 's/^/   │ /' "$TM_LAST_OUT"; return 0; }

# Run any terraform command, capturing output into $TM_LAST_OUT.
# Returns terraform's exit code. Example:  tm_tf state list || tm_fail "..."
tm_tf() {
  terraform "$@" -no-color >"$TM_LAST_OUT" 2>&1
}

# Same as tm_tf but for subcommands that don't accept -no-color at the end
# (e.g. `terraform state mv a b`). Output is still captured.
tm_tf_raw() {
  NO_COLOR=1 terraform "$@" >"$TM_LAST_OUT" 2>&1
}

# ── Terraform workflow helpers ────────────────────────────────────────────────

# terraform init (no -upgrade; uses the shared plugin cache). Fails the level on error.
tm_init() {
  if ! terraform init -input=false -no-color >"$TM_LAST_OUT" 2>&1; then
    tm_show_last
    tm_fail "${1:-terraform init failed}"
  fi
}

# terraform validate. Fails the level on error.
tm_validate() {
  if ! tm_tf validate; then
    tm_show_last
    tm_fail "${1:-terraform validate failed}"
  fi
}

# Run `terraform plan -detailed-exitcode` with extra args; echoes the exit code
# (0 = no changes, 1 = error, 2 = changes). Never aborts. Output in $TM_LAST_OUT.
#   code=$(tm_plan_code)            code=$(tm_plan_code -var env=prod)
tm_plan_code() {
  terraform plan -detailed-exitcode -input=false -no-color "$@" >"$TM_LAST_OUT" 2>&1
  echo $?
}

# Plan must succeed (0 or 2). Fails the level on error.
tm_plan_ok() {
  local code
  code=$(tm_plan_code "$@")
  if [[ "$code" != "0" && "$code" != "2" ]]; then
    tm_show_last
    tm_fail "${TM_MSG:-terraform plan failed}"
  fi
}

# terraform apply -auto-approve with extra args. Fails the level on error.
tm_apply() {
  if ! terraform apply -auto-approve -input=false -no-color "$@" >"$TM_LAST_OUT" 2>&1; then
    tm_show_last
    tm_fail "${TM_MSG:-terraform apply failed}"
  fi
}

# After an apply, a second plan must report no changes (idempotency).
tm_assert_no_changes() {
  local code
  code=$(tm_plan_code "$@")
  if [[ "$code" == "2" ]]; then
    grep -E '^\s*[#~+-]' "$TM_LAST_OUT" | head -20 | sed 's/^/   │ /'
    tm_fail "${TM_MSG:-plan is not clean — Terraform still wants to change something}"
  elif [[ "$code" != "0" ]]; then
    tm_show_last
    tm_fail "${TM_MSG:-terraform plan failed}"
  fi
}

# Save a plan and write its JSON to $TM_TMP/plan.json. Fails the level on plan error.
#   tm_plan_json [extra plan args]   then:  jq '...' "$TM_TMP/plan.json"
tm_plan_json() {
  if ! terraform plan -input=false -no-color -out="$TM_TMP/tm.tfplan" "$@" >"$TM_LAST_OUT" 2>&1; then
    tm_show_last
    tm_fail "${TM_MSG:-terraform plan failed}"
  fi
  terraform show -json "$TM_TMP/tm.tfplan" >"$TM_TMP/plan.json" 2>/dev/null \
    || tm_fail "could not render plan as JSON"
}

# Addresses the saved plan would delete (destroy or replace), one per line.
tm_plan_deletes() {
  jq -r '.resource_changes[]? | select(.change.actions | index("delete")) | .address' "$TM_TMP/plan.json"
}

# Plan must contain no destroy/replace actions (useful for refactor levels).
tm_assert_no_destroy() {
  tm_plan_json "$@"
  local deletes
  deletes=$(tm_plan_deletes)
  if [[ -n "$deletes" ]]; then
    sed 's/^/   │ would delete: /' <<<"$deletes"
    tm_fail "${TM_MSG:-plan would destroy or replace existing resources}"
  fi
}

# ── Outputs ───────────────────────────────────────────────────────────────────

# Echo raw output value (strings/numbers/bools). Empty + non-zero if missing.
tm_output_raw() { terraform output -raw "$1" 2>/dev/null; }

# Echo output value as compact JSON. Empty + non-zero if missing.
tm_output_json() { terraform output -json "$1" 2>/dev/null | jq -c . 2>/dev/null; }

# Assert an output equals an expected string (raw comparison).
tm_assert_output() {
  local name="$1" expected="$2" actual
  actual=$(tm_output_raw "$name") || tm_fail "output '$name' does not exist"
  [[ "$actual" == "$expected" ]] || tm_fail "output '$name' = '$actual', expected '$expected'"
}

# Assert a jq expression evaluates to true on an output's JSON value.
#   tm_assert_output_jq servers 'length == 3 and all(.[]; startswith("web-"))'
tm_assert_output_jq() {
  local name="$1" expr="$2" json
  json=$(tm_output_json "$name") || tm_fail "output '$name' does not exist"
  [[ -n "$json" ]] || tm_fail "output '$name' does not exist"
  [[ "$(jq -r "$expr" <<<"$json" 2>/dev/null)" == "true" ]] \
    || tm_fail "${3:-output '$name' has unexpected value: $json}"
}

# ── State ─────────────────────────────────────────────────────────────────────

tm_state_list() { terraform state list 2>/dev/null; }
tm_state_has() { tm_state_list | grep -qxF "$1"; }
tm_state_count() { tm_state_list | grep -c . ; }

tm_assert_in_state()     { tm_state_has "$1" || tm_fail "${2:-'$1' is not in state}"; }
tm_assert_not_in_state() { tm_state_has "$1" && tm_fail "${2:-'$1' should not be in state}"; return 0; }

# Echo one attribute of a resource from `terraform show -json` state.
#   tm_state_attr 'random_pet.name' 'id'
tm_state_attr() {
  terraform show -json 2>/dev/null | jq -r --arg a "$1" --arg k "$2" '
    [.values.root_module | .. | objects | select(has("resources")) | .resources[]]
    | map(select(.address == $a)) | .[0].values[$k] // empty'
}

# ── Files & config ────────────────────────────────────────────────────────────

tm_assert_file() { [[ -f "$1" ]] || tm_fail "${2:-expected file '$1' to exist}"; }
tm_assert_no_file() { [[ ! -e "$1" ]] || tm_fail "${2:-'$1' should not exist}"; }

# Exact file content comparison (trailing newline sensitive).
tm_assert_file_equals() {
  local f="$1" expected="$2"
  tm_assert_file "$f"
  [[ "$(cat "$f"; echo x)" == "${expected}x" ]] || {
    echo "   expected:"; printf '%s' "$expected" | sed 's/^/   │ /'; echo
    echo "   actual:";   sed 's/^/   │ /' "$f"
    tm_fail "${3:-content of '$f' is not what the mission requires}"
  }
}

tm_assert_file_contains() {
  tm_assert_file "$1"
  grep -qF -- "$2" "$1" || tm_fail "${3:-'$1' does not contain: $2}"
}

# Grep across the player's Terraform config files (*.tf, *.tfvars, *.tftest.hcl, recursively).
tm_config_has() {
  grep -rqE --include='*.tf' --include='*.tfvars' --include='*.tftest.hcl' \
    --include='*.tf.json' --include='*.tfvars.json' --exclude-dir=.terraform -- "$1" . 2>/dev/null
}
tm_assert_config_has()  { tm_config_has "$1" || tm_fail "${2:-config must contain pattern: $1}"; }
tm_assert_config_lacks() { tm_config_has "$1" && tm_fail "${2:-config must not contain pattern: $1}"; return 0; }

# File mode as octal (portable macOS/Linux), e.g. 600
tm_file_mode() { stat -f '%Lp' "$1" 2>/dev/null || stat -c '%a' "$1" 2>/dev/null; }

# Mark a value recorded by setup.sh so validate.sh can compare later.
# Stored inside the workspace in a hidden dir that survives between commands.
tm_record() { mkdir -p "$WORKSPACE/.tm"; printf '%s' "$2" >"$WORKSPACE/.tm/$1"; }
tm_recall() { cat "$WORKSPACE/.tm/$1" 2>/dev/null; }
