#!/usr/bin/env bash
set -euo pipefail

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -ne 0 ]] && [[ $PLAN_EXIT -ne 2 ]]; then
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
    exit 1
fi

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw result 2>/dev/null || echo "__MISSING__")
EXPECTED="a-b-c"
if [[ "$ACTUAL" == "$EXPECTED" ]]; then
    echo "✅ PASS: output 'result' = '$ACTUAL'"
    exit 0
fi
echo "❌ FAIL: expected '$EXPECTED', got '$ACTUAL'"
exit 1
