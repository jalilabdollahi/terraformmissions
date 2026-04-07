#!/usr/bin/env bash
set -euo pipefail

# Fix ISSUE 1: Remove stale random_id.old_resource from state
if terraform state show random_id.old_resource > /dev/null 2>&1; then
    echo "INFO: Removing stale random_id.old_resource from state (Issue 1)"
    terraform state rm random_id.old_resource
fi

# Apply — should handle Issue 2 (moved block) and Issue 3 (length fixed)
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed after recovery steps"
    exit 1
fi

# Verify all 3 resources are in state
for res in new_name config_error healthy_resource; do
    if ! terraform state show "random_string.${res}" > /dev/null 2>&1; then
        echo "FAIL: random_string.${res} not found in state after recovery"
        exit 1
    fi
done

# Verify config_error now has correct length (not 0)
CONFIG_LEN=$(terraform output -raw config_error_result 2>/dev/null | wc -c | tr -d ' ')
if [[ "$CONFIG_LEN" -ge 8 ]]; then
    echo "PASS: Full recovery playbook succeeded — all 3 issues resolved"
    exit 0
fi

echo "FAIL: config_error resource may still have wrong length"
exit 1
