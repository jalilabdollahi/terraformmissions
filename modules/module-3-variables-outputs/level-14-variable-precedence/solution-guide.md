# Walkthrough — Skyward Range

1. **Diagnose.** `terraform plan` shows the sheet with `T-5 min countdown` although `terraform.tfvars` says 45.
2. **Find every source.** `ls *.tfvars*`: `terraform.tfvars` and `rehearsal.auto.tfvars`. You can also check the
   plan: the value comes from "somewhere", Terraform does not say where.
3. **Know the order** (lowest to highest): defaults → environment `TF_VAR_*` → `terraform.tfvars` →
   `terraform.tfvars.json` → `*.auto.tfvars` (lexical) → `-var` / `-var-file` on the command line.
   So `rehearsal.auto.tfvars` beats `terraform.tfvars`.
4. **Fix.** Delete `rehearsal.auto.tfvars` (it was a one-day dry-run override).
5. **Verify.** `terraform output countdown_minutes` is `45`.
