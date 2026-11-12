# Walkthrough — Thistledown Apiary

1. **Run `terraform init`.** It fails while installing providers:
   ```
   Error: Failed to query available provider packages
   ... provider registry registry.terraform.io does not have a provider named
   registry.terraform.io/hashicorp/localfile
   ```
2. **Find the source.** `grep -n source terraform.tf` shows `source = "hashicorp/localfile"`.
   Resources named `local_file` use the provider whose type is `local`.
3. **Fix the address** to `hashicorp/local` (namespace `hashicorp`, type `local`).
4. **Re-run `terraform init`**, then `terraform apply`. The `.terraform.lock.hcl` file now records the
   real provider.
