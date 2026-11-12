#!/usr/bin/env bash
# Merge-request gate for the lens order sheets.
# Fails at the first problem; never changes files and never applies.
set -euo pipefail
cd "$(dirname "$0")/.."

terraform fmt -check -recursive
terraform init -input=false
terraform validate
terraform plan -input=false -out=ci-plan.tfplan
echo "pipeline ok: ci-plan.tfplan saved"
