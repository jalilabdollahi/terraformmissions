# Walkthrough — Glasshouse 3

1. **Diagnose.** Run `terraform plan`. The file `controller/settings.json` would have `temp_c: 18`,
   `vents: manual` — the defaults — although `prod.tfvars` says 24 / auto. No error is shown, which is
   what makes this tricky.
2. **Reason.** Terraform auto-loads, in this order: `terraform.tfvars`, `terraform.tfvars.json`, then
   `*.auto.tfvars` and `*.auto.tfvars.json` in lexical order. `prod.tfvars` matches none of those.
3. **Fix.** `mv prod.tfvars prod.auto.tfvars` (or merge into `terraform.tfvars`).
4. **Verify.** `terraform plan` now shows the 24 / auto / 6 values; `terraform apply` writes them to
   `controller/settings.json`.
