#!/usr/bin/env bash
set -euo pipefail

# First apply to create resources
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: initial apply failed"
    exit 1
fi

# Plan destroy should succeed (not blocked by prevent_destroy on temp_resource)
PLAN_OUT=$(terraform plan -destroy -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -q "prevent_destroy"; then
    echo "FAIL: plan -destroy is blocked by prevent_destroy — lifecycle block may not be fixed"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: plan -destroy succeeded — prevent_destroy removed from temp_resource"
    exit 0
fi

echo "FAIL: plan -destroy returned unexpected error"
exit 1
