#!/usr/bin/env bash
set -euo pipefail

# First apply only resource_a with -target
if ! terraform apply -auto-approve -target=random_string.resource_a -no-color -input=false 2>&1; then
    echo "FAIL: targeted apply of resource_a failed"
    exit 1
fi

# Then apply the full config
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: full terraform apply failed"
    exit 1
fi

echo "PASS: targeted apply and full apply both succeeded"
exit 0
