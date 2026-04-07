#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -parallelism=10 -no-color -input=false 2>&1; then
    echo "FAIL: terraform apply failed"
    exit 1
fi

COUNT=$(terraform output -raw token_count 2>/dev/null || echo "0")
if [[ "$COUNT" == "10" ]]; then
    echo "PASS: 10 random_string resources created with parallelism=10"
    exit 0
fi
echo "FAIL: expected token_count=10, got $COUNT"
exit 1
