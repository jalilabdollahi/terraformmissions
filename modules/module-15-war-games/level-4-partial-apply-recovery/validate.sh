#!/usr/bin/env bash
set -euo pipefail

# Apply to complete the partial deployment
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Verify all 3 resources exist in state
for res in resource_a resource_b resource_c; do
    if ! terraform state show "random_string.${res}" > /dev/null 2>&1; then
        echo "FAIL: random_string.${res} not found in state"
        exit 1
    fi
done

# Verify the output has 3 elements
COUNT=$(terraform output -json all_three 2>/dev/null | python3 -c "import json,sys; print(len(json.load(sys.stdin)))" 2>/dev/null || echo "0")
if [[ "$COUNT" == "3" ]]; then
    echo "PASS: partial apply recovered — all 3 resources exist in state"
    exit 0
fi

echo "FAIL: expected 3 resources in output, got $COUNT"
exit 1
