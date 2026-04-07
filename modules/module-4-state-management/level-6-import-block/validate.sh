#!/usr/bin/env bash
set -euo pipefail

# Create the config.txt file so the import block has something to import
echo "configuration data" > "$(pwd)/config.txt"

terraform plan -detailed-exitcode -no-color -input=false > /tmp/plan_out.txt 2>&1
PLAN_EXIT=$?
if [[ $PLAN_EXIT -eq 0 ]] || [[ $PLAN_EXIT -eq 2 ]]; then
    echo "✅ PASS: terraform plan succeeded with import block"
    exit 0
fi
cat /tmp/plan_out.txt
echo "❌ FAIL: terraform plan failed (exit $PLAN_EXIT)"
exit 1
