#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed (check random_password length)"
    exit 1
fi

STATE_VERSION=$(terraform state pull | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['version'])" 2>/dev/null || echo "")
if [[ -z "$STATE_VERSION" ]]; then
    echo "❌ FAIL: could not parse state version from terraform state pull"
    exit 1
fi

echo "✅ PASS: state pulled successfully, state format version = $STATE_VERSION"
exit 0
