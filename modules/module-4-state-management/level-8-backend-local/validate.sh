#!/usr/bin/env bash
set -euo pipefail

if ! terraform init -reconfigure -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init failed (check backend path)"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: terraform init and plan succeeded with local backend"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
exit 1
