#!/usr/bin/env bash
set -euo pipefail

# Create a test workspace, plan, then clean up
terraform workspace new test-ws-level10 > /dev/null 2>&1 || true

if terraform plan -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    echo "✅ PASS: terraform plan succeeded without interactive input"
    terraform workspace select default > /dev/null 2>&1
    terraform workspace delete test-ws-level10 > /dev/null 2>&1 || true
    exit 0
fi

cat /tmp/tf_out.txt
terraform workspace select default > /dev/null 2>&1 || true
terraform workspace delete test-ws-level10 > /dev/null 2>&1 || true
echo "❌ FAIL: terraform plan failed or required interactive input"
exit 1
