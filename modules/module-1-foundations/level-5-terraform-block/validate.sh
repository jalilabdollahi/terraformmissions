#!/usr/bin/env bash
set -euo pipefail
if terraform init -no-color -input=false 2>&1 && terraform validate -no-color 2>&1; then
    echo "✅ PASS: init and validate succeeded"
    exit 0
fi
echo "❌ FAIL"
exit 1
