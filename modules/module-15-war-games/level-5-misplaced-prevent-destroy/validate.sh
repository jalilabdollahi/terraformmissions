#!/usr/bin/env bash
source "$TM_LIB"

CH=$(tm_recall charter_id); BERTH=$(tm_recall berth_tag)
[[ -n "$CH" && -n "$BERTH" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

# --- protection must sit on the charter and nowhere else ---
python3 - <<'PY' || exit 1
import re, pathlib, sys
files = [p for p in pathlib.Path(".").rglob("*.tf") if ".terraform" not in p.parts]
total = 0
on_charter = False
for p in files:
    t = p.read_text()
    n = len(re.findall(r"prevent_destroy\s*=\s*true", t))
    total += n
    m = re.search(r'resource\s+"random_id"\s+"yard_charter"\s*\{(.*?)\n\}\n', t, re.S)
    if m and re.search(r"prevent_destroy\s*=\s*true", m.group(1)):
        on_charter = True
if not on_charter:
    print("❌ FAIL: the yard charter serial has no prevent_destroy guard - the critical object is unprotected")
    sys.exit(1)
if total != 1:
    print("❌ FAIL: prevent_destroy is still set on something that is meant to be retired")
    sys.exit(1)
PY
[[ $? -eq 0 ]] || exit 1
tm_assert_config_lacks 'ignore_changes[[:space:]]*=[[:space:]]*all' "ignore_changes = all is not a fix"

tm_validate

for r in 'module.annex[0].random_pet.berth_tag' 'module.annex[0].random_integer.crane_slot' 'module.annex[0].local_file.berth_sheet'; do
  tm_assert_not_in_state "$r" "annex object $r is still alive - the decommission is not finished"
done
tm_assert_in_state random_id.yard_charter "the charter serial is gone from state"
[[ "$(tm_state_attr random_id.yard_charter id)" == "$CH" ]] \
  || tm_fail "the yard charter serial changed ($CH -> $(tm_state_attr random_id.yard_charter id)) - the yard would have to re-license"

tm_assert_no_destroy
TM_MSG="plan is not clean after the decommission" tm_assert_no_changes

tm_assert_no_file registry/annex-berths.txt "the annex berth sheet should be gone with the annex"
tm_assert_file_contains registry/yard-manifest.txt "CH-" "yard manifest lost the charter line"
tm_assert_file_contains registry/yard-manifest.txt "$(tm_output_raw charter_serial)"
if grep -q "$BERTH" registry/yard-manifest.txt; then tm_fail "yard manifest still lists the retired annex berth"; fi
tm_assert_output charter_serial "CH-$(printf '%s' "$CH" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')"
tm_pass "annex retired, charter serial preserved and now the only protected object"
