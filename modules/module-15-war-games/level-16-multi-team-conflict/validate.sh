#!/usr/bin/env bash
set -euo pipefail

# Apply team1 first
cd team1
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: team1 apply failed"
    exit 1
fi
cd ..

# Plan team2 — should succeed with correct output key
cd team2
terraform init -no-color -input=false 2>&1
terraform plan -detailed-exitcode -no-color -input=false 2>&1
PLAN_CODE=$?
cd ..

if [[ $PLAN_CODE -eq 0 ]] || [[ $PLAN_CODE -eq 2 ]]; then
    echo "PASS: multi-team conflict resolved — team2 uses correct remote state key"
    exit 0
fi
echo "FAIL: team2 plan failed — check remote state output key reference"
exit 1
