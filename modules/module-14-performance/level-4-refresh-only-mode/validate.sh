#!/usr/bin/env bash
set -euo pipefail

# Initial apply
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: initial apply failed"
    exit 1
fi

# Run refresh-only to update state without making infrastructure changes
terraform apply -refresh-only -auto-approve -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]]; then
    echo "PASS: refresh-only apply succeeded"
    exit 0
fi
echo "FAIL: refresh-only apply failed (exit $CODE)"
exit 1
