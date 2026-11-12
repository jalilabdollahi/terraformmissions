#!/usr/bin/env bash
source "$TM_LIB"

COND=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
for m in re.finditer(r"postcondition\s*\{([^}]*)\}", text):
    c = re.search(r"condition\s*=\s*(.*)", m.group(1))
    if c:
        print(c.group(1).strip())
PY
)
[[ -n "$COND" ]] || tm_fail "the batch record needs its postcondition rules (keep them)"
N=$(grep -c . <<<"$COND")
[[ "$N" -ge 2 ]] || tm_fail "both rules (litres and cure days) must stay as postconditions"
grep -q 'litres' <<<"$COND" || tm_fail "no postcondition checks the litres"
grep -q 'cure_days' <<<"$COND" || tm_fail "no postcondition checks the cure days"
grep -q 'self\.' <<<"$COND" || tm_fail "a postcondition should talk about its own resource through 'self'"
grep -q 'terraform_data\.varnish_batch' <<<"$COND" && tm_fail "a postcondition may not name its own resource; it has to use self"
grep -q '5' <<<"$COND" || tm_fail "the limits of 5 litres / 5 days have to remain in the rules"

tm_validate "the configuration does not validate"
tm_apply

[[ "$(tm_state_attr terraform_data.varnish_batch output | jq -r .litres)" == "4" ]] || tm_fail "the batch record does not show 4 litres"
tm_assert_file_equals labels/vx-2210.txt "VX-2210: 4 L, cure 6 days"$'\n'
tm_assert_no_changes
tm_pass "the varnish batch record applies and its postconditions use self"
