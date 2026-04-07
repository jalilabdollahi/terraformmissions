#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color 2>&1; then
    echo "PASS: terraform init succeeded — provider constraints are compatible"
    exit 0
fi
echo "FAIL: terraform init failed — check provider version constraints"
exit 1
