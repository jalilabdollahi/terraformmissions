#!/usr/bin/env bash
set -euo pipefail

# First apply to get v1 state
terraform apply -auto-approve -no-color -input=false > /dev/null 2>&1 || true

# With v2 trigger, plan should show replacement
terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: plan shows changes (trigger updated to v2)"
    exit 0
elif [[ $PLAN_EXIT -eq 0 ]]; then
    echo "❌ FAIL: plan shows no changes — trigger was not updated"
    exit 1
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: plan error (exit $PLAN_EXIT)"
    exit 1
fi
