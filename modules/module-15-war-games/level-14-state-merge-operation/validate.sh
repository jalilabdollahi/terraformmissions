#!/usr/bin/env bash
set -euo pipefail

# Apply config-alpha and config-beta to simulate pre-merge state
cd config-alpha
terraform init -no-color -input=false 2>&1
terraform apply -auto-approve -no-color -input=false 2>&1
cd ..

cd config-beta
terraform init -no-color -input=false 2>&1
terraform apply -auto-approve -no-color -input=false 2>&1
cd ..

# Apply config-merged
cd config-merged
terraform init -no-color -input=false 2>&1
if ! terraform apply -auto-approve -no-color -input=false 2>&1; then
    echo "FAIL: config-merged apply failed"
    exit 1
fi

# Both resources should exist in merged state
if ! terraform state show random_string.alpha_token > /dev/null 2>&1; then
    echo "FAIL: alpha_token missing from merged state"
    exit 1
fi

if ! terraform state show random_string.beta_token > /dev/null 2>&1; then
    echo "FAIL: beta_token missing from merged state"
    exit 1
fi
cd ..

echo "PASS: state merge succeeded — both alpha and beta resources in merged config"
exit 0
