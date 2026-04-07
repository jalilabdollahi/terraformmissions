#!/usr/bin/env bash
set -euo pipefail

if terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "✅ PASS: terraform apply succeeded"
    exit 0
fi
echo "❌ FAIL: terraform apply failed"
exit 1
