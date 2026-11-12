# Walkthrough — Emberfall Ignore List

1. Think about what Terraform writes into a repo: `.terraform/` (provider binaries), `terraform.tfstate` and its `.backup`, `terraform.tfstate.d/<ws>/`,
   `errored.tfstate`, saved plans, `crash.log`, variable files, and the committed-on-purpose `.terraform.lock.hcl`.
2. The starting file ignores `.terraform`, only `terraform.tfstate`, and the lock file. It misses everything else — including `prod.tfvars` with the key — and
   the lock file is wrongly ignored (it should be committed so everyone installs the same provider versions).
3. Replace it with:
   ```gitignore
   .terraform/
   *.tfstate
   *.tfstate.*
   *.tfplan
   *.tfvars
   *.tfvars.json
   crash.log
   crash.*.log
   ```
   `*.tfvars` does not match `terraform.tfvars.example`, so the template remains tracked.
4. Verify with `git check-ignore -v <path>` in a repo, run `terraform apply` so the audit report updates, and type `check`.
5. If `prod.tfvars` or a state file was already committed, ignoring it is not enough: `git rm --cached` it and rotate the secrets.
