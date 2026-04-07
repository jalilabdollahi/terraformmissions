#!/usr/bin/env bash
set -euo pipefail

terraform init -no-color -input=false 2>&1

if terraform test -no-color 2>&1; then
    echo "✅ PASS: terraform test passed"
    exit 0
fi
echo "❌ FAIL: terraform test failed"
exit 1
