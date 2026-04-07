#!/usr/bin/env bash
set -euo pipefail

# Remove the bad lock file so init can regenerate it
rm -f .terraform.lock.hcl

if ! terraform init -upgrade -no-color -input=false > /tmp/init_out.txt 2>&1; then
    cat /tmp/init_out.txt
    echo "❌ FAIL: terraform init -upgrade failed"
    exit 1
fi

if terraform validate -no-color 2>&1; then
    echo "✅ PASS: init -upgrade succeeded and lock file regenerated"
    exit 0
fi
echo "❌ FAIL: terraform validate failed after init"
exit 1
