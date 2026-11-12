# Walkthrough — Copperkettle Brewing

1. **Diagnose.** `terraform validate`: `Error: Variables not allowed ... Variables may not be used here.`
   pointing at `default = "${var.brewery}-batch"`.
2. **Reason.** Defaults are evaluated at the moment variables are declared, before any other value exists.
   Only literals (and constant-only expressions) are allowed.
3. **Fix.** Keep `batch_label` as an optional input with `default = null`, then compute the effective value:
   ```hcl
   locals {
     batch_label = coalesce(var.batch_label, "${var.brewery}-batch")
   }
   ```
   Use `local.batch_label` in the `local_file` content and in the output.
4. **Verify.** `terraform plan -var brewery=Foxglove` shows `Foxglove-batch`; adding `-var batch_label=X` shows `X`.
