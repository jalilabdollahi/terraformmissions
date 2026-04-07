#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

ACTUAL=$(terraform output -raw readme_text 2>/dev/null || echo "__MISSING__")

if echo "$ACTUAL" | grep -q "TerraformMissions"; then
    echo "✅ PASS: output 'readme_text' contains readable text"
    exit 0
fi
echo "❌ FAIL: output does not contain expected plain text. Got: $ACTUAL"
exit 1
