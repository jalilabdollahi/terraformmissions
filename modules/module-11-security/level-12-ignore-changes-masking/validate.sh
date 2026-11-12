#!/usr/bin/env bash
source "$TM_LIB"
tm_validate "the configuration does not validate"
tm_apply

F=gate/access-rules.json
tm_assert_file "$F" "gate/access-rules.json is missing"
if grep -q '0\.0\.0\.0/0' "$F"; then tm_fail "the gate is still open to 0.0.0.0/0 — the tightened rules never reached the file"; fi
[[ "$(jq -c '.allow_from' "$F" 2>/dev/null)" == '["10.20.0.0/16"]' ]] || tm_fail "gate rules should allow only 10.20.0.0/16 (file says: $(jq -c '.allow_from' "$F" 2>/dev/null))"
[[ "$(tm_file_mode "$F")" == "640" ]] || tm_fail "gate/access-rules.json has mode $(tm_file_mode "$F"); the config says 0640"
tm_assert_no_changes

# Probe on a COPY of the workspace: a future edit of the rules must show up in the plan.
PROBE="$TM_TMP/probe"
rm -rf "$PROBE"; mkdir -p "$PROBE"
cp -R "$WORKSPACE/." "$PROBE/"
rm -rf "$PROBE/.tm"
python3 - "$PROBE/main.tf" <<'PY'
import sys
p = sys.argv[1]
t = open(p).read()
open(p, "w").write(t.replace("10.20.0.0/16", "10.99.0.0/16").replace('"0640"', '"0600"'))
PY
( cd "$PROBE" && terraform plan -detailed-exitcode -input=false -no-color >"$TM_TMP/probe.out" 2>&1 ); PCODE=$?
[[ $PCODE -eq 2 ]] || tm_fail "editing the rules in code produces no plan at all (exit $PCODE) — something is still masking changes to this file"
tm_pass "rules reached the file, and future edits to them are visible in plans again"
