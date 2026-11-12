#!/usr/bin/env bash
# Sugar-glass workshop deploy wrapper used by the CI job.
cd "$(dirname "$0")/.." || exit 1
terraform init -input=false
# TEMP: -parallelism=1 makes the slip step "work" -- see ticket WRKS-212
terraform apply -auto-approve -input=false -parallelism=1
