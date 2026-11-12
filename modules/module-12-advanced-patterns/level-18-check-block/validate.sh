#!/usr/bin/env bash
source "$TM_LIB"

# status.txt belongs to another system: it stays degraded
tm_assert_file_contains silo/status.txt "degraded" "silo/status.txt is written by the sensor system and must not be edited"

SHAPE=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
m = re.search(r'check\s+"[^"]+"\s*\{(.*?)\n\}', text, re.S)
body = m.group(1) if m else ""
print("check" if m else "", "scoped" if re.search(r'data\s+"local_file"', body) else "", "assert" if re.search(r"\bassert\s*\{", body) else "")
rest = text.replace(m.group(0), "") if m else text
print("blocking" if re.search(r"\b(pre|post)condition\s*\{", rest) else "")
PY
)
L1=$(head -1 <<<"$SHAPE"); L2=$(tail -1 <<<"$SHAPE")
grep -q check <<<"$L1" || tm_fail "express the sensor rule as a check block"
grep -q scoped <<<"$L1" || tm_fail "the check block should read the status through its own scoped data source"
grep -q assert <<<"$L1" || tm_fail "the check block needs an assert"
grep -q blocking <<<"$L2" && tm_fail "no precondition or postcondition may remain: the sensor must not block the apply"

tm_validate "the configuration does not validate"
tm_apply
tm_assert_file_equals reports/silo-4-shift.txt "silo 4 shift report: intake logged"$'\n'

# the degraded sensor must still be reported, as a warning
tm_plan_json
OPEN=$(jq '[.resource_changes[]? | select(.change.actions != ["no-op"] and .change.actions != ["read"])] | length' "$TM_TMP/plan.json")
[[ "$OPEN" == "0" ]] || tm_fail "a plan after apply should have no resource changes ($OPEN pending)"
grep -q 'Check block assertion failed' "$TM_LAST_OUT" || { tm_show_last; tm_fail "the degraded sensor should still be reported as a 'Check block assertion failed' warning"; }
grep -q 'Warning' "$TM_LAST_OUT" || tm_fail "the sensor problem must be a warning, not silence"
tm_pass "the shift report is written and the degraded sensor surfaces as a warning"
