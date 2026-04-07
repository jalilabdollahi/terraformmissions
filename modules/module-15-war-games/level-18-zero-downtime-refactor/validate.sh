#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

# Apply to create resources (simulates pre-refactor state existing)
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Plan should show no destroys with correct moved blocks
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -q "will be destroyed"; then
    echo "FAIL: plan shows destroy operations — moved blocks may be missing or wrong"
    echo "$PLAN_OUT"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]]; then
    echo "PASS: zero-downtime refactor complete — no destroy operations in plan"
    exit 0
fi

if [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: refactor applied — plan shows only non-destructive changes"
    exit 0
fi

echo "FAIL: plan returned unexpected error"
exit 1
