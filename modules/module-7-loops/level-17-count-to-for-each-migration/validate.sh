#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

OUTPUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
CODE=$?
echo "$OUTPUT"
if [[ $CODE -eq 1 ]]; then
    echo "❌ FAIL: terraform plan returned error"
    exit 1
fi
if echo "$OUTPUT" | grep -q "will be destroyed"; then
    echo "❌ FAIL: plan shows resource destruction — moved block may be missing"
    exit 1
fi
echo "✅ PASS: plan completed without destruction"
exit 0
