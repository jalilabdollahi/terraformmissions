#!/usr/bin/env bash
set -euo pipefail

# terraform init must succeed with the corrected provider source
if ! terraform init -no-color -input=false 2>&1; then
    echo "FAIL: terraform init failed — provider source may be wrong"
    exit 1
fi

# Check that a lock file exists
if [[ ! -f ".terraform.lock.hcl" ]]; then
    echo "FAIL: .terraform.lock.hcl not found — commit this file for CI/CD performance"
    exit 1
fi

# Plan to confirm the config is valid end-to-end
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: init succeeded, lock file exists, and plan succeeded"
    exit 0
fi
echo "FAIL: terraform plan failed after successful init"
exit 1
