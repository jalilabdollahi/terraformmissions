#!/usr/bin/env bash
source "$TM_LIB"

DESTROY_CMD=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
for m in re.finditer(r"provisioner\s+\"local-exec\"\s*\{([^}]*)\}", text):
    if re.search(r"when\s*=\s*destroy", m.group(1)):
        c = re.search(r"command\s*=\s*(.*)", m.group(1))
        print(c.group(1) if c else "")
PY
)
[[ -n "$DESTROY_CMD" ]] || tm_fail "keep the destroy-time provisioner that writes the 'closed' line"
grep -q 'self\.' <<<"$DESTROY_CMD" || tm_fail "the destroy-time provisioner has to read the ticket through self"
grep -q 'terraform_data\.repair_ticket\|var\.' <<<"$DESTROY_CMD" && tm_fail "a destroy-time provisioner may only use self (not the resource's name or variables)"

tm_validate "the configuration does not validate"
tm_apply

grep -qF 'opened CC-2041 (Black Forest wall cuckoo)' repairs/bench.log 2>/dev/null || tm_fail "repairs/bench.log has no 'opened' line for CC-2041"

# Replace the ticket: that destroys the old record, so its destroy-time provisioner must log the closing.
BEFORE=$(grep -cF 'closed CC-2041' repairs/bench.log 2>/dev/null)
tm_apply -replace=terraform_data.repair_ticket
AFTER=$(grep -cF 'closed CC-2041' repairs/bench.log 2>/dev/null)
[[ "$AFTER" -gt "$BEFORE" ]] || tm_fail "replacing the ticket did not log 'closed CC-2041': the destroy-time provisioner is not working"

tm_assert_no_changes
tm_pass "the destroy-time provisioner reads the ticket through self and logged the closing"
