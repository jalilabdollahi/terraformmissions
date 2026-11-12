#!/usr/bin/env bash
# Sugar-glass workshop deploy wrapper used by the CI job.
cd "$(dirname "$0")/.." || exit 1
terraform init -input=false
terraform apply -auto-approve -input=false
