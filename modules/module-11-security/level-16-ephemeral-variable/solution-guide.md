# Walkthrough — Redline Kart Track Token

1. `TF_VAR_gateway_token=demo-not-a-real-secret-gokart-6612 terraform apply`, then `terraform state pull | grep gokart`: the token is in the state
   file, inside `terraform_data.publish_calendar.input`.
2. `sensitive = true` only redacts display. Anything stored in a resource argument is written to state.
3. Declare the variable `ephemeral = true`. Terraform will not persist it to state or plan files. Ephemeral values may only be used in places that are not stored:
   provisioner and connection blocks, provider configuration, ephemeral resources, write-only arguments and other ephemeral variables/outputs.
4. Remove `token = ...` from `input`, and in the provisioner use `GATEWAY_TOKEN = var.gateway_token`. If you try to keep the token in `input` Terraform will refuse with
   *Invalid use of ephemeral value ... not a write-only attribute*.
5. Apply from a clean state (or `terraform apply -replace=terraform_data.publish_calendar` to re-run the provisioner) and type `check`.
