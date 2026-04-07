#!/usr/bin/env bash
set -euo pipefail

if terraform init -no-color -input=false -reconfigure 2>&1; then
    echo "✅ PASS: terraform init succeeded"
    exit 0
fi
echo "❌ FAIL: terraform init failed — backend block likely still has interpolation"
exit 1
