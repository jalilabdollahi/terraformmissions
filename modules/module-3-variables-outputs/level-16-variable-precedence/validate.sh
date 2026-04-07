#!/usr/bin/env bash
set -euo pipefail

terraform plan -var="environment=staging" -detailed-exitcode -no-color -input=false 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: terraform plan with -var=environment=staging succeeded"
    exit 0
fi
echo "FAIL: terraform plan -var=environment=staging failed (exit $CODE)"
exit 1
