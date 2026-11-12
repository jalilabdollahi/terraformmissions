#!/usr/bin/env bash
source "$TM_LIB"
# config/backend-prod.hcl is fixed by the solution overlay: the key is "path", not "file_path".
terraform init -reconfigure -backend-config=config/backend-prod.hcl
terraform apply -auto-approve
