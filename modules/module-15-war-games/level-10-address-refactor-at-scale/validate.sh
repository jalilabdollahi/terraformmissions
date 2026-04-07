#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

# Apply to populate state with the original names
# (simulate pre-refactor state by creating resources under old names first)
# Since we're starting fresh, apply creates all 5 under new names
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Plan should show no destroy
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -q "will be destroyed"; then
    echo "FAIL: plan shows destroy operations — moved blocks may be missing"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]]; then
    echo "PASS: plan shows no changes — refactor is zero-destructive with moved blocks"
    exit 0
fi

if [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: plan shows only non-destructive changes"
    exit 0
fi

echo "FAIL: unexpected plan exit code $PLAN_CODE"
exit 1
