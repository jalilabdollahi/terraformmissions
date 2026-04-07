#!/usr/bin/env bash
set -euo pipefail

# Apply Team A first to create their state file
cd team-a
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: team-a apply failed"
    exit 1
fi
cd ..

# Plan Team B — should succeed with correct output key references
cd team-b
terraform init -no-color -input=false 2>&1
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
cd ..

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: cross-team state references are correct — team-b plan succeeded"
    exit 0
fi
echo "FAIL: team-b plan failed — check remote state output key references"
exit 1
