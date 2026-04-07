#!/usr/bin/env bash
set -euo pipefail

if TF_LOG=DEBUG terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded"
    exit 0
fi
echo "FAIL: terraform init failed — check provider source"
exit 1
