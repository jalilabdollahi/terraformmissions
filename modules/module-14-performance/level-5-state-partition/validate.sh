#!/usr/bin/env bash
set -euo pipefail

# Apply config-a first to create their state file
cd config-a
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-a apply failed"
    exit 1
fi
cd ..

# Apply config-b which reads config-a's state
cd config-b
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-b apply failed — check remote state output key"
    exit 1
fi
cd ..

echo "PASS: both configs applied successfully with correct remote state reference"
exit 0
