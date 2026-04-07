#!/usr/bin/env bash
set -euo pipefail

# Run plan and save to file
if ! terraform plan -out=tfplan -no-color -input=false 2>&1; then
    echo "FAIL: terraform plan -out=tfplan failed"
    exit 1
fi

# Apply the saved plan file (no re-planning)
if ! terraform apply -no-color tfplan 2>&1; then
    echo "FAIL: terraform apply tfplan failed"
    exit 1
fi

echo "PASS: plan file workflow (plan -out + apply plan) succeeded"
exit 0
