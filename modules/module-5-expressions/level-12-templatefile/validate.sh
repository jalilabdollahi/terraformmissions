#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

RENDERED=$(find . -name "rendered.txt" 2>/dev/null | head -1)
if [[ -z "$RENDERED" ]]; then
    echo "❌ FAIL: rendered.txt not found"
    exit 1
fi

if grep -q "myapp" "$RENDERED" 2>/dev/null; then
    echo "✅ PASS: rendered.txt contains the app name"
    exit 0
fi
echo "❌ FAIL: rendered.txt does not contain the app name — template variable mismatch?"
cat "$RENDERED" 2>/dev/null || true
exit 1
