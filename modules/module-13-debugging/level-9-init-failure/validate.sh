#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded"
    exit 0
fi
echo "FAIL: terraform init failed"
exit 1
