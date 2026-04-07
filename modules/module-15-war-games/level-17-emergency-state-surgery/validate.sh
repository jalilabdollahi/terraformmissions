#!/usr/bin/env bash
set -euo pipefail

# Step 1: Remove the stale state entry for the old resource type
if terraform state show random_id.legacy_id > /dev/null 2>&1; then
    echo "INFO: Removing stale random_id.legacy_id from state"
    terraform state rm random_id.legacy_id
fi

# Step 2: Apply cleanly with the new resource type
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed after state surgery"
    exit 1
fi

# Step 3: Verify the new resource type is in state
if terraform state show random_string.service_token > /dev/null 2>&1; then
    echo "PASS: Emergency state surgery succeeded — service_token in state with correct type"
    exit 0
fi

echo "FAIL: random_string.service_token not found in state after apply"
exit 1
