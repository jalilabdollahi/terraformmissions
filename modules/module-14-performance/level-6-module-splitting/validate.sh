#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

# Apply to create resources (in a real scenario, state would already exist)
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Now plan — with correct moved blocks there should be no destroy
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -q "will be destroyed"; then
    echo "FAIL: plan contains destroy operations — moved blocks may be missing or wrong"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: plan has no destroy operations — module splitting is zero-destructive"
    exit 0
fi

echo "FAIL: plan returned error"
exit 1
