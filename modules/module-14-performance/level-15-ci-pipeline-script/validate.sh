#!/usr/bin/env bash
source "$TM_LIB"

tm_assert_file ci/pipeline.sh "ci/pipeline.sh is missing"

REAL_TF=$(command -v terraform)
[[ -n "$REAL_TF" ]] || tm_fail "terraform not found"
SHIM="$TM_TMP/bin"
mkdir -p "$SHIM"
cat > "$SHIM/terraform" <<SH
#!/usr/bin/env bash
echo "\$*" >> "\$TM_CALLS"
exec "$REAL_TF" "\$@"
SH
chmod +x "$SHIM/terraform"

# Fresh scratch copy of the workspace (no state, no .terraform).
fresh() { # fresh <name>
  local d="$TM_TMP/$1"
  rm -rf "$d"; mkdir -p "$d"
  python3 - "$WORKSPACE" "$d" <<'PY'
import os, shutil, sys
src, dst = sys.argv[1:3]
for root, dirs, files in os.walk(src):
    dirs[:] = [x for x in dirs if x not in (".terraform", ".tm", "orders")]
    rel = os.path.relpath(root, src)
    os.makedirs(os.path.join(dst, rel), exist_ok=True)
    for f in files:
        if f.endswith(".tfstate") or f.endswith(".backup") or f.endswith(".tfplan"):
            continue
        shutil.copy2(os.path.join(root, f), os.path.join(dst, rel, f))
PY
  echo "$d"
}

# run <scratch dir> <start dir relative to it>; sets RUN_CODE, CALLS
run_pipeline() {
  local d="$1" start="$2"
  export TM_CALLS="$d/calls.log"; : > "$TM_CALLS"
  RUN_CODE=$( cd "$d/$start" && env PATH="$SHIM:$PATH" TM_CALLS="$TM_CALLS" TF_INPUT= bash "$d/ci/pipeline.sh" </dev/null >"$d/run.out" 2>&1; echo $? )
  CALLS=$(cat "$TM_CALLS")
}

pos() { grep -n -m1 -E "$2" <<<"$1" | cut -d: -f1; }   # pos <calls> <regex>

# ---- A: healthy repository ---------------------------------------------------------------
A=$(fresh good)
run_pipeline "$A" .
if [[ "$RUN_CODE" != "0" ]]; then
  sed 's/^/   │ /' "$A/run.out" | tail -15
  tm_fail "ci/pipeline.sh exits $RUN_CODE on a healthy repository"
fi
p_fmt=$(pos "$CALLS" '^fmt( |$)'); p_init=$(pos "$CALLS" '^init( |$)')
p_val=$(pos "$CALLS" '^validate( |$)'); p_plan=$(pos "$CALLS" '^plan( |$)')
[[ -n "$p_fmt" && -n "$p_init" && -n "$p_val" && -n "$p_plan" ]] \
  || tm_fail "the pipeline must run fmt, init, validate and plan; it ran: $(tr '\n' ';' <<<"$CALLS")"
(( p_fmt < p_init && p_init < p_val && p_val < p_plan )) \
  || tm_fail "the steps must run in the order fmt, init, validate, plan"
grep -qE '^fmt .*-check' <<<"$CALLS" || tm_fail "terraform fmt must run with -check (CI must not rewrite files)"
grep -qE '^fmt .*-recursive' <<<"$CALLS" || tm_fail "terraform fmt must run with -recursive so every directory is checked"
grep -qE '^init .*-input=false' <<<"$CALLS" || tm_fail "terraform init must run with -input=false"
grep -qE '^plan .*-input=false' <<<"$CALLS" || tm_fail "terraform plan must run with -input=false"
plan_line=$(grep -E '^plan( |$)' <<<"$CALLS" | head -1)
grep -qE -- '-out(=| )' <<<"$plan_line" || tm_fail "terraform plan must save its result with -out"
if grep -qE '^(apply|destroy)( |$)' <<<"$CALLS"; then tm_fail "a CI gate must never apply or destroy"; fi

planfile=$(sed -nE 's/.*-out[= ]([^ ]+).*/\1/p' <<<"$plan_line" | head -1)
[[ -n "$planfile" ]] || tm_fail "could not find the plan file name"
[[ -f "$A/$planfile" ]] || tm_fail "the saved plan '$planfile' was not left in the repository directory"
(cd "$A" && terraform show -json "$planfile" >"$A/plan.json" 2>/dev/null) || tm_fail "the saved plan is not readable"
creates=$(jq '[.resource_changes[]? | select(.change.actions == ["create"])] | length' "$A/plan.json")
[[ "$creates" -ge 3 ]] || tm_fail "the saved plan holds $creates creations; the lens order sheets must be planned"

# ---- A2: started from another directory ------------------------------------------------------
A2=$(fresh subdir)
run_pipeline "$A2" ci
[[ "$RUN_CODE" == "0" ]] || { sed 's/^/   │ /' "$A2/run.out" | tail -10; tm_fail "ci/pipeline.sh fails when started from inside ci/; it must work from any directory"; }

# ---- B: badly formatted file ---------------------------------------------------------------------
B=$(fresh unformatted)
python3 - "$B/main.tf" <<'PY'
import sys
p = sys.argv[1]
t = open(p).read().replace('\n  filename = "${path.module}/orders', '\n          filename   =   "${path.module}/orders', 1)
open(p, "w").write(t)
PY
before=$(shasum "$B/main.tf" | cut -d' ' -f1)
run_pipeline "$B" .
[[ "$RUN_CODE" != "0" ]] || tm_fail "the pipeline passed although main.tf is badly formatted"
[[ "$(shasum "$B/main.tf" | cut -d' ' -f1)" == "$before" ]] || tm_fail "the pipeline rewrote main.tf; fmt must only check in CI"
if grep -qE '^(init|validate|plan)( |$)' <<<"$CALLS"; then
  tm_fail "after the formatting check failed the pipeline went on ($(tr '\n' ';' <<<"$CALLS")); it must stop at the first failing step"
fi

# ---- C: invalid configuration ------------------------------------------------------------------------
C=$(fresh invalid)
cat >> "$C/main.tf" <<'HCL'

output "broken" {
  value = local_file.no_such_sheet.id
}
HCL
run_pipeline "$C" .
[[ "$RUN_CODE" != "0" ]] || tm_fail "the pipeline passed although the configuration is invalid"
if grep -qE '^plan( |$)' <<<"$CALLS"; then
  tm_fail "terraform plan ran after validate failed; stop at the first failing step"
fi

# ---- D: plan fails (required variable nobody can answer in CI) -------------------------------------------
D=$(fresh needs_input)
cat >> "$D/main.tf" <<'HCL'

variable "optician" {
  type = string
}

resource "local_file" "signed_off" {
  filename = "${path.module}/orders/signed-off.txt"
  content  = var.optician
}
HCL
run_pipeline "$D" .
[[ "$RUN_CODE" != "0" ]] || tm_fail "the pipeline passed although plan could not complete (missing variable); it must fail, never wait for input"

tm_pass "fmt-check, init, validate and plan -out run in order, stop at the first failure, and leave a valid plan"
