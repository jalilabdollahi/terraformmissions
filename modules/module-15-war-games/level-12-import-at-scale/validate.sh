#!/usr/bin/env bash
set -euo pipefail

# Run plan — with correct import IDs the plan should recognize the imports
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
PLAN_CODE=$?

if echo "$PLAN_OUT" | grep -qi "error"; then
    echo "FAIL: plan contains errors — import IDs may be wrong"
    echo "$PLAN_OUT"
    exit 1
fi

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: plan succeeded — all import IDs are correct"
    exit 0
fi

echo "FAIL: plan returned unexpected exit code $PLAN_CODE"
exit 1
