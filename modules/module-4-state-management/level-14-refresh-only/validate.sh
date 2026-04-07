#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: initial apply failed"
    exit 1
fi

# Apply refresh-only to update state
if ! terraform apply -refresh-only -auto-approve -no-color -input=false > /tmp/refresh_out.txt 2>&1; then
    cat /tmp/refresh_out.txt
    echo "❌ FAIL: terraform apply -refresh-only failed"
    exit 1
fi

echo "✅ PASS: apply and refresh-only both succeeded"
exit 0
