# Walkthrough - Dive Log Signer

1. `terraform plan` stops immediately with an error like
   `provider registry.terraform.io/hashicorp/tls: required by this configuration but no version is selected`
   and the hint `terraform init`.
2. `cat terraform.tf` shows the new `tls` entry in `required_providers`; `ls .terraform/providers/registry.terraform.io/hashicorp`
   shows only `local` and `random`.
3. Save the address from the error: `mkdir -p answers && echo "missing_provider=registry.terraform.io/hashicorp/tls" > answers/missing.txt`.
4. `terraform init` installs the provider and adds it to `.terraform.lock.hcl`. Existing state is untouched.
5. `terraform apply` creates the key and the signature card. The boat name from earlier stays the same.
6. `check`.
