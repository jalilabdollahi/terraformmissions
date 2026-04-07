#!/usr/bin/env bash
set -euo pipefail

if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_out.txt 2>&1; then
    cat /tmp/tf_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

# Simulate external drift by modifying the file directly
TF_FILE=$(find . -maxdepth 2 -name "tracked.txt" 2>/dev/null | head -1 || true)
if [[ -n "$TF_FILE" ]] && [[ -f "$TF_FILE" ]]; then
    echo "drifted content modified outside terraform" > "$TF_FILE"
fi

# plan with detailed exitcode — exit 2 means changes detected (drift)
terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?

if [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: drift detected (plan exit code 2)"
    exit 0
elif [[ $PLAN_EXIT -eq 0 ]]; then
    echo "❌ FAIL: no drift detected (exit 0)"
    exit 1
else
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed with error (exit $PLAN_EXIT)"
    exit 1
fi
