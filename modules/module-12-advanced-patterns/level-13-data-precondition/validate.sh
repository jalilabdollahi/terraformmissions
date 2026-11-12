#!/usr/bin/env bash
source "$TM_LIB"

BLOCKS=$(python3 - <<'PY'
import glob, re
text = "\n".join(open(f).read() for f in glob.glob("*.tf"))
text = re.sub(r"#.*", "", text)
d = re.search(r'data\s+"local_file"\s+"ladder"\s*\{(.*?)\n\}', text, re.S)
body = d.group(1) if d else ""
print("pre" if re.search(r"\bprecondition\s*\{", body) else "", "post" if re.search(r"\bpostcondition\s*\{", body) else "")
PY
)
grep -q pre <<<"$BLOCKS" || tm_fail "data.local_file.ladder needs a precondition that checks the input before the file is read"
grep -q post <<<"$BLOCKS" || tm_fail "data.local_file.ladder needs a postcondition that checks the content that was read"

tm_validate "the configuration does not validate"

# 1. the real file passes
code=$(tm_plan_code)
[[ "$code" == "0" || "$code" == "2" ]] || { tm_show_last; tm_fail "plan fails with the default ladder file"; }

# 2. a missing file must be stopped by the precondition, before the read
code=$(tm_plan_code -var ladder_file=data/missing.csv)
[[ "$code" == "1" ]] || tm_fail "a missing ladder file should make the plan fail"
grep -qi 'precondition failed' "$TM_LAST_OUT" || { tm_show_last; tm_fail "a missing file must be rejected by the precondition (not by the provider's own read error)"; }

# 3. a wrong file type is rejected too
code=$(tm_plan_code -var ladder_file=data/ladder-bad.txt)
[[ "$code" == "1" ]] && grep -qi 'precondition failed' "$TM_LAST_OUT" || tm_fail "a ladder file that is not a .csv must be rejected by the precondition"

# 4. a CSV with the wrong header must be rejected after the read
code=$(tm_plan_code -var ladder_file=data/ladder-bad.csv)
[[ "$code" == "1" ]] || tm_fail "a CSV with the wrong header should make the plan fail"
grep -qi 'postcondition failed' "$TM_LAST_OUT" || { tm_show_last; tm_fail "the wrong header must be rejected by a postcondition on the data source"; }

tm_apply
tm_assert_output champion "Ingrid Halvorsen"
tm_assert_file_equals club/standings.txt "champion: Ingrid Halvorsen"$'\n'"players: 5"$'\n'
tm_assert_no_changes
tm_pass "the data source is guarded before and after the read"
