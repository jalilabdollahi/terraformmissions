#!/usr/bin/env bash
set -euo pipefail

# Remove corrupted lock file if present
rm -f .terraform.lock.hcl

if terraform init -upgrade -no-color 2>&1; then
    echo "PASS: terraform init succeeded after removing corrupted lock file"
    exit 0
fi
echo "FAIL: terraform init failed even after removing lock file"
exit 1
