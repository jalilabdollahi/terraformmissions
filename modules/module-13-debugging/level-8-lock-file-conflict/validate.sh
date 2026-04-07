#!/usr/bin/env bash
set -euo pipefail

rm -f .terraform.lock.hcl

if terraform init -no-color 2>&1 && terraform validate -no-color 2>&1; then
    echo "PASS: init and validate succeeded after removing corrupted lock file"
    exit 0
fi
echo "FAIL: init or validate failed"
exit 1
