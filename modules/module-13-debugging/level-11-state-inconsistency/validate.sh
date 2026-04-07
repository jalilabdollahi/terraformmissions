#!/usr/bin/env bash
set -euo pipefail

# Remove stale state file
rm -f terraform.tfstate terraform.tfstate.backup

if terraform init -no-color 2>&1 && terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "PASS: apply succeeded after removing stale state"
    exit 0
fi
echo "FAIL: apply failed"
exit 1
