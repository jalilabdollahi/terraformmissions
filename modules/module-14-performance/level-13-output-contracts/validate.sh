#!/usr/bin/env bash
source "$TM_LIB"

# rigging.tf belongs to another team.
tm_assert_file_contains rigging.tf 'module.stage.power_kw' "rigging.tf must keep reading module.stage.power_kw; it is not yours to change"

# --- the producer's side of the contract -------------------------------------------------
python3 - <<'PY' || exit 1
import glob, re, sys
text = "".join(open(f).read() for f in glob.glob("modules/stage/*.tf"))
def block(name):
    m = re.search(r'output\s+"%s"\s*\{(.*?)\n\}' % name, text, re.S)
    return m.group(1) if m else None
c = block("stage_contract")
if c is None:
    print("❌ FAIL: modules/stage has no output \"stage_contract\"")
    sys.exit(1)
if "var.contract_version" not in c:
    print("❌ FAIL: the contract's version must come from var.contract_version, not a literal")
    sys.exit(1)
l = block("power_kw")
if l is None:
    print("❌ FAIL: the legacy output power_kw must stay in modules/stage until teams migrate")
    sys.exit(1)
if not re.search(r'^\s*deprecated\s*=\s*"[^"]{8,}"', l, re.M):
    print("❌ FAIL: power_kw must carry a deprecated message that tells consumers what to use instead")
    sys.exit(1)
PY
if grep -q 'output "stage_id"\|output "power_budget_kw"' modules/stage/*.tf 2>/dev/null; then
  tm_fail "the loose outputs stage_id / power_budget_kw should be folded into the contract, not published separately"
fi

tm_init
tm_validate
tm_apply

# Contract shape: exactly these keys.
tm_assert_output_jq contract '(keys | sort) == ["power_budget_kw","stage_id","version"]' \
  "the contract object must have exactly the keys version, stage_id and power_budget_kw"
tm_assert_output_jq contract '.version == "2.1" and .stage_id == "main-stage" and .power_budget_kw == 48' \
  "the contract values are wrong"
tm_assert_output rigging_limit 'Rigging load limit: 48 kW'
tm_assert_file_equals rigs/lighting.txt $'Lighting rig on main-stage: budget 48 kW (contract 2.1)\n'
tm_assert_no_changes

# --- the consumer's side: a major bump must be refused ------------------------------------
SCR="$TM_TMP/scratch"
mkdir -p "$SCR"
python3 - "$WORKSPACE" "$SCR" <<'PY' || exit 1
import os, re, shutil, sys
src, dst = sys.argv[1:3]
for root, dirs, files in os.walk(src):
    dirs[:] = [d for d in dirs if d not in (".terraform", ".tm")]
    rel = os.path.relpath(root, src)
    os.makedirs(os.path.join(dst, rel), exist_ok=True)
    for f in files:
        if f.endswith(".tfstate") or f.endswith(".backup"):
            continue
        shutil.copy2(os.path.join(root, f), os.path.join(dst, rel, f))
p = os.path.join(dst, "main.tf")
t = open(p).read()
t = re.sub(r'(module\s+"stage"\s*\{\s*\n\s*source\s*=\s*"[^"]+"\s*\n)', r'\1  contract_version = "3.0"\n', t, 1)
open(p, "w").write(t)
PY
(cd "$SCR" && terraform init -input=false -no-color >"$TM_LAST_OUT" 2>&1) || { tm_show_last; tm_fail "scratch init failed"; }
code=$(cd "$SCR" && terraform plan -input=false -no-color >"$TM_LAST_OUT" 2>&1; echo $?)
if [[ "$code" == "0" || "$code" == "2" ]]; then
  tm_fail "when the stage module publishes contract 3.0 the lighting plan still succeeds; lighting.tf needs a precondition on the major version"
fi
grep -qi 'precondition\|2\.x\|resource precondition' "$TM_LAST_OUT" || { tm_show_last; tm_fail "the plan failed for a reason other than a lighting precondition"; }

tm_pass "stage_contract is versioned, power_kw is deprecated but alive, and lighting refuses contract 3.0"
