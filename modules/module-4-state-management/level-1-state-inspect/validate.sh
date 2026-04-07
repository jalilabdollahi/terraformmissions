#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

for addr in random_string.alpha random_string.beta random_string.gamma; do
    if ! terraform state show "$addr" > /dev/null 2>&1; then
        echo "❌ FAIL: $addr not found in state"
        exit 1
    fi
done

OUT=$(terraform output -raw last_string 2>/dev/null || echo "__MISSING__")
if [[ "$OUT" == "__MISSING__" ]] || [[ -z "$OUT" ]]; then
    echo "❌ FAIL: output 'last_string' is missing or empty"
    exit 1
fi

echo "✅ PASS: all resources in state and output 'last_string' = '$OUT'"
exit 0
