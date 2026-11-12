#!/usr/bin/env bash
source "$TM_LIB"
terraform providers lock -fs-mirror=vendor/provider-mirror \
  -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64
terraform init -input=false
