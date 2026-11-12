#!/usr/bin/env bash
source "$TM_LIB"

IDS=$(tm_recall ids)
[[ -n "$IDS" ]] || tm_fail "mission state is missing — run 'reset' to restore the level"

# One resource block, data-driven.
blocks=$(cat ./*.tf 2>/dev/null | grep -cE '^[[:space:]]*resource[[:space:]]+"local_file"')
[[ "$blocks" == "1" ]] || tm_fail "found $blocks local_file resource blocks in the config; there must be exactly one"
tm_assert_config_has 'for_each' "the single resource has to be driven by for_each"
tm_assert_config_has 'resource[[:space:]]+"local_file"[[:space:]]+"seat"' "name the resource local_file.seat"

python3 - <<'PY' || exit 1
import glob, re, sys
literal = 0
lines = 0
for f in glob.glob("*.tf"):
    t = open(f).read()
    t = re.sub(r'moved\s*\{[^}]*\}', '', t)
    literal += len(re.findall(r'"[a-f]-[1-5]-\d\d"', t))
    lines += len([l for l in t.splitlines() if l.strip() and not l.strip().startswith('#')])
if literal > 6:
    print("❌ FAIL: the seat keys are typed out by hand (%d literal keys) instead of generated" % literal)
    sys.exit(1)
if lines > 120:
    print("❌ FAIL: the config is still %d lines long outside moved blocks; generate the seats from data" % lines)
    sys.exit(1)
PY

tm_init
tm_validate

# Plan first: moves only, nothing destroyed or replaced.
TM_MSG="the plan would destroy or replace existing tag files" tm_assert_no_destroy
creates=$(jq '[.resource_changes[]? | select(.change.actions == ["create"])] | length' "$TM_TMP/plan.json")
[[ "$creates" == "0" ]] || tm_fail "the plan would create $creates new objects; every tag already exists"
tm_apply

state=$(tm_state_list)
n=$(grep -c '^local_file\.seat\["[a-f]-[1-5]-[0-9][0-9]"\]$' <<<"$state")
[[ "$n" == "300" ]] || tm_fail "state has $n instances at local_file.seat[\"<key>\"], expected 300 (keys like \"a-1-01\")"
if grep -q '^local_file\.seat_' <<<"$state"; then
  tm_fail "old copy-paste addresses are still in state"
fi

terraform show -json | jq -r '[.values.root_module.resources[] | .values.id] | sort | join(",")' > "$TM_TMP/ids2"
[[ "$(shasum "$TM_TMP/ids2" | cut -d' ' -f1)" == "$IDS" ]] \
  || tm_fail "some tags were re-created (their IDs changed) instead of moved"

files=$(ls seats | grep -c '\.txt$')
[[ "$files" == "300" ]] || tm_fail "seats/ holds $files files, expected 300"
tm_assert_file_equals seats/c-4-07.txt $'Block C, row 4, seat 07\n'
tm_assert_file_equals seats/f-5-10.txt $'Block F, row 5, seat 10\n'

tm_assert_no_changes
tm_pass "300 tags now come from one for_each resource and none of them was re-created"
