#!/usr/bin/env bash
source "$TM_LIB"

LIN=$(tm_recall lineage); SER=$(tm_recall serial); SEAL=$(tm_recall seal)
[[ -n "$LIN" && -n "$SER" && -n "$SEAL" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

tm_assert_config_lacks 'ignore_changes' "lifecycle tricks do not recover state"

terraform state list >/dev/null 2>&1 || tm_fail "Terraform cannot read the state"
python3 - "$LIN" "$SER" <<'PY' || exit 1
import json, sys
lin, ser = sys.argv[1], int(sys.argv[2])
s = json.load(open("terraform.tfstate"))
if s["lineage"] != lin:
    print("❌ FAIL: the state lineage changed - other copies and CI caches chain from the original lineage")
    sys.exit(1)
if s["serial"] <= ser:
    print("❌ FAIL: the state serial did not advance past the incident state; the write history is ambiguous")
    sys.exit(1)
PY
[[ $? -eq 0 ]] || exit 1

[[ "$(tm_state_attr random_id.docket_seal id)" == "$SEAL" ]] || tm_fail "the docket seal is missing or was re-rolled"
for c in c1 c2 c3; do
  [[ "$(tm_state_attr "random_pet.courtroom[\"$c\"]" id)" == "$(tm_recall "pet_$c")" ]] \
    || tm_fail "courtroom $c does not carry its current call-sign (c3 was legitimately re-rolled; c2 was lost with the seal)"
done
tm_assert_not_in_state 'local_file.archive_index' "the decommissioned archive index crept back into state"

tm_assert_no_destroy
TM_MSG="plan is not clean after recovery" tm_assert_no_changes

for c in c1 c2 c3; do
  tm_assert_file_contains "docket/$c.txt" "$(tm_recall "pet_$c")"
  tm_assert_file_contains "docket/$c.txt" "seal $(printf '%s' "$SEAL" | python3 -c 'import sys,base64;print(base64.urlsafe_b64decode(sys.stdin.read()+"==").hex())')"
done
tm_pass "live lineage preserved, serial advanced, all four identifiers match the paper record"
