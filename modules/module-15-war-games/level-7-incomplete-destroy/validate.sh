#!/usr/bin/env bash
set -euo pipefail

# Apply should succeed — removed blocks clean up ghost state entries
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed — ghost resources may not be cleaned up correctly"
    exit 1
fi

# Ghost resources should no longer be in state
if terraform state show random_string.resource_ghost_a > /dev/null 2>&1; then
    echo "FAIL: random_string.resource_ghost_a still in state after removed block"
    exit 1
fi

if terraform state show random_string.resource_ghost_b > /dev/null 2>&1; then
    echo "FAIL: random_string.resource_ghost_b still in state after removed block"
    exit 1
fi

# Active resource should still be in state
if ! terraform state show random_string.resource_active > /dev/null 2>&1; then
    echo "FAIL: random_string.resource_active missing from state"
    exit 1
fi

echo "PASS: Ghost resources removed from state, active resource intact"
exit 0
