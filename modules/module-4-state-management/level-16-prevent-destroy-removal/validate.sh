#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

terraform plan -destroy -detailed-exitcode -no-color -input=false > /tmp/destroy_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: destroy plan succeeded (prevent_destroy is not blocking)"
    exit 0
fi

if grep -q "prevent_destroy" /tmp/destroy_out.txt 2>/dev/null; then
    echo "❌ FAIL: prevent_destroy is still set to true"
else
    cat /tmp/destroy_out.txt
    echo "❌ FAIL: destroy plan failed (exit $PLAN_EXIT)"
fi
exit 1
