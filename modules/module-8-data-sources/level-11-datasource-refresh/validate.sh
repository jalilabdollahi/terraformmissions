#!/usr/bin/env bash
set -euo pipefail

# First apply to set up the resource
if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

# Now check that plan -refresh-only exits cleanly
terraform plan -refresh-only -no-color -input=false > /tmp/tf_refresh.txt 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    # Verify output is readable text (not base64)
    ACTUAL=$(terraform output -raw file_text 2>/dev/null || echo "__MISSING__")
    if echo "$ACTUAL" | grep -q "v1 content"; then
        echo "✅ PASS: data source returns readable text content"
        exit 0
    fi
    echo "❌ FAIL: output does not contain expected text. Got: $ACTUAL"
    exit 1
fi
echo "❌ FAIL: terraform plan -refresh-only failed"
cat /tmp/tf_refresh.txt
exit 1
