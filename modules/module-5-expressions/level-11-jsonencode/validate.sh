#!/usr/bin/env bash
set -euo pipefail

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -ne 0 ]] && [[ $PLAN_EXIT -ne 2 ]]; then
    cat /tmp/plan_out.txt
    echo "❌ FAIL: terraform plan failed"
    exit 1
fi

if ! terraform apply -auto-approve -no-color -input=false > /tmp/apply_out.txt 2>&1; then
    cat /tmp/apply_out.txt
    echo "❌ FAIL: terraform apply failed"
    exit 1
fi

OUT=$(terraform output -raw config_json 2>/dev/null || echo "")
if python3 -c "import json, sys; json.loads(sys.argv[1])" "$OUT" 2>/dev/null; then
    echo "✅ PASS: config_json is valid JSON"
    exit 0
fi
echo "❌ FAIL: config_json is not valid JSON or missing"
exit 1
