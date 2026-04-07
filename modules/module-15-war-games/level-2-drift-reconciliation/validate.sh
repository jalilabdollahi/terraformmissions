#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: apply failed"
    exit 1
fi

# Check 1: api_key length should be 16
API_LEN=$(terraform output -raw api_key_length 2>/dev/null || echo "0")
if [[ "$API_LEN" != "16" ]]; then
    echo "FAIL: api_key_length expected 16, got $API_LEN"
    exit 1
fi

# Check 2: session_token should have special=true
SESSION_SPECIAL=$(terraform output -raw session_has_special 2>/dev/null || echo "false")
if [[ "$SESSION_SPECIAL" != "true" ]]; then
    echo "FAIL: session_has_special expected true, got $SESSION_SPECIAL"
    exit 1
fi

# Check 3: admin_token should have upper=true
ADMIN_UPPER=$(terraform output -raw admin_has_upper 2>/dev/null || echo "false")
if [[ "$ADMIN_UPPER" != "true" ]]; then
    echo "FAIL: admin_has_upper expected true, got $ADMIN_UPPER"
    exit 1
fi

echo "PASS: All 3 drift reconciliation checks passed"
exit 0
