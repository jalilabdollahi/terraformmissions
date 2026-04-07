#!/usr/bin/env bash
set -euo pipefail

PLAN_OUTPUT=$(terraform plan -no-color -input=false 2>&1)
PLAN_CODE=$?

if [[ $PLAN_CODE -ne 0 ]] && [[ $PLAN_CODE -ne 2 ]]; then
    echo "FAIL: terraform plan failed"
    echo "$PLAN_OUTPUT"
    exit 1
fi

# Check that the plan output redacts the password with (sensitive value)
if echo "$PLAN_OUTPUT" | grep -q "(sensitive value)"; then
    echo "PASS: sensitive output is redacted in plan output"
    exit 0
fi

# Also check the output block itself shows sensitive = true
if echo "$PLAN_OUTPUT" | grep -q "sensitive"; then
    echo "PASS: sensitive marker found in plan output"
    exit 0
fi

echo "FAIL: database_password output does not appear to be marked as sensitive"
echo "$PLAN_OUTPUT"
exit 1
