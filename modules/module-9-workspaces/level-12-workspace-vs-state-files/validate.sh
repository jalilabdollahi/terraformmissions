#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color -input=false -reconfigure 2>&1; then
    echo "✅ PASS: terraform init succeeded with static backend config"
    exit 0
fi
echo "❌ FAIL: terraform init failed — check the backend block for interpolation"
exit 1
