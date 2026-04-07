#!/usr/bin/env bash
set -euo pipefail

# Clean up any previous state
rm -f output.txt terraform.tfstate terraform.tfstate.backup

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw file_content 2>/dev/null || echo "__MISSING__")
if echo "$ACTUAL" | grep -q "written by terraform"; then
    echo "✅ PASS: data source read the file created by the resource"
    exit 0
fi
echo "❌ FAIL: output did not contain expected content. Got: $ACTUAL"
exit 1
