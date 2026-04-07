#!/usr/bin/env bash
set -euo pipefail

# Plan must succeed
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
if [[ $PLAN_CODE -ne 0 ]] && [[ $PLAN_CODE -ne 2 ]]; then
    echo "FAIL: plan failed in default workspace"
    exit 1
fi

# Apply to check outputs
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

NAMES=$(terraform output -json token_names 2>/dev/null || echo "[]")

# In default workspace, expect "default-token-1" pattern
if echo "$NAMES" | grep -q "default-token-1"; then
    echo "PASS: workspace naming convention is correct (workspace-token-N with dash separator)"
    exit 0
fi

echo "FAIL: token names do not follow expected convention 'workspace-token-N'"
echo "Got: $NAMES"
exit 1
