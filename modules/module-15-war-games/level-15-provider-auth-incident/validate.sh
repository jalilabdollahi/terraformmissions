#!/usr/bin/env bash
set -euo pipefail

if terraform validate -no-color 2>&1; then
    echo "✅ PASS: Configuration is valid"
    exit 0
fi
echo "❌ FAIL: terraform validate failed"
exit 1
