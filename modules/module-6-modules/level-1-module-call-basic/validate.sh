#!/usr/bin/env bash
set -euo pipefail

if ! terraform init -no-color -input=false 2>&1; then
    echo "❌ FAIL: terraform init failed"
    exit 1
fi

terraform plan -detailed-exitcode -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "✅ PASS: terraform init + plan succeeded"
    exit 0
fi
echo "❌ FAIL: terraform plan returned error (exit $CODE)"
exit 1
