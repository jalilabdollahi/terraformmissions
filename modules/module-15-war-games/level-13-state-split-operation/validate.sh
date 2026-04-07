#!/usr/bin/env bash
set -euo pipefail

# Apply config-first (creates res_1, res_2, res_3; should not destroy res_4, res_5)
cd config-first
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-first apply failed"
    exit 1
fi

# Plan should not show destroy for res_4 or res_5
PLAN_OUT=$(terraform plan -detailed-exitcode -no-color -input=false 2>&1)
if echo "$PLAN_OUT" | grep -q "will be destroyed"; then
    echo "FAIL: config-first plan would destroy resources — moved blocks may be missing"
    exit 1
fi
cd ..

# Apply config-second (creates res_4, res_5 independently)
cd config-second
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-second apply failed"
    exit 1
fi

RES4=$(terraform output -raw res_4_id 2>/dev/null || echo "")
RES5=$(terraform output -raw res_5_id 2>/dev/null || echo "")
cd ..

if [[ -n "$RES4" ]] && [[ -n "$RES5" ]]; then
    echo "PASS: state split succeeded — config-second has res_4 and res_5"
    exit 0
fi

echo "FAIL: config-second outputs missing"
exit 1
