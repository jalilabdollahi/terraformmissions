#!/usr/bin/env bash
set -euo pipefail

# Step 1: Detect and remove the corrupt state file
if [[ -f "terraform.tfstate" ]]; then
    if ! python3 -c "import json, sys; json.load(open('terraform.tfstate'))" 2>/dev/null; then
        echo "INFO: Corrupt state file detected — removing it for clean recovery"
        rm -f terraform.tfstate terraform.tfstate.backup
    fi
fi

# Step 2: Apply cleanly
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: clean apply after state removal failed"
    exit 1
fi

# Step 3: Verify both resources exist in state
if ! terraform state show random_string.service_a > /dev/null 2>&1; then
    echo "FAIL: random_string.service_a not found in state after recovery"
    exit 1
fi

if ! terraform state show random_string.service_b > /dev/null 2>&1; then
    echo "FAIL: random_string.service_b not found in state after recovery"
    exit 1
fi

# Step 4: Verify outputs are readable
A_ID=$(terraform output -raw service_a_id 2>/dev/null || echo "")
B_ID=$(terraform output -raw service_b_id 2>/dev/null || echo "")

if [[ -n "$A_ID" ]] && [[ -n "$B_ID" ]]; then
    echo "PASS: State corruption recovered — both resources exist and outputs are readable"
    exit 0
fi

echo "FAIL: Outputs missing after recovery"
exit 1
