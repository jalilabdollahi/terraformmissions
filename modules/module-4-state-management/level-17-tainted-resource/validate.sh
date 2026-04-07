#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

if ! terraform taint null_resource.task > /tmp/taint_out.txt 2>&1; then
    cat /tmp/taint_out.txt
    echo "❌ FAIL: terraform taint null_resource.task failed — resource may not exist"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: taint succeeded and plan shows replacement"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: plan should show replacement after taint (exit $PLAN_EXIT)"
exit 1
