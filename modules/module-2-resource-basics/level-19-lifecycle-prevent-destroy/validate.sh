#!/usr/bin/env bash
set -euo pipefail

# First apply to create the resource
if ! terraform apply -auto-approve -no-color -input=false > /tmp/tf_apply.txt 2>&1; then
    cat /tmp/tf_apply.txt
    echo "FAIL: terraform apply failed"
    exit 1
fi

# Now try plan -destroy; exit 0 or 2 means success (no error), exit 1 means blocked
terraform plan -destroy -detailed-exitcode -no-color -input=false > /tmp/tf_plan.txt 2>&1
CODE=$?
if [[ $CODE -eq 0 ]] || [[ $CODE -eq 2 ]]; then
    echo "PASS: terraform plan -destroy succeeded (exit $CODE)"
    exit 0
fi
cat /tmp/tf_plan.txt
echo "FAIL: terraform plan -destroy returned error (exit $CODE) -- prevent_destroy may still be true"
exit 1
