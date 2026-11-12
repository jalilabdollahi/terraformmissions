#!/usr/bin/env bash
source "$TM_LIB"
# solution/main.tf (env = terraform.workspace) is already overlaid.
terraform state mv \
  -state=terraform.tfstate.d/staging/terraform.tfstate \
  -state-out=terraform.tfstate.d/prod/terraform.tfstate \
  random_id.post_key random_id.post_key
terraform state mv \
  -state=terraform.tfstate.d/staging/terraform.tfstate \
  -state-out=terraform.tfstate.d/prod/terraform.tfstate \
  local_file.post_card local_file.post_card
terraform workspace select prod
terraform apply -auto-approve
terraform workspace select staging
terraform apply -auto-approve
