#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed — check resource types"
    exit 1
fi

RESOURCE_COUNT=$(terraform state list 2>/dev/null | wc -l | tr -d ' ')
if [[ "$RESOURCE_COUNT" -eq 3 ]]; then
    echo "✅ PASS: apply succeeded — all 3 resources in state"
    exit 0
fi
echo "❌ FAIL: expected 3 resources in state, got $RESOURCE_COUNT"
terraform state list 2>/dev/null || true
exit 1
