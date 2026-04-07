#!/usr/bin/env bash
set -euo pipefail

# First apply to create the resource
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: initial apply failed"
    exit 1
fi

# Plan with -refresh=false should succeed (exit 0 = no changes, exit 2 = changes, exit 1 = error)
terraform plan -refresh=false -detailed-exitcode -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: plan -refresh=false succeeded"
    exit 0
fi
echo "FAIL: plan -refresh=false returned error (exit $CODE)"
exit 1
