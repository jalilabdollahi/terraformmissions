# Walkthrough — Deepfreeze Backups

1. **Diagnose.** `terraform plan` fails with `Invalid template interpolation value ... The expression result is null.`
   on `modules/vault/main.tf`.
2. **Trace.** The root passes `retention_days = var.retention_override`, which defaults to `null`. In the
   module, the variable has `default = 30`, but a default only applies when the argument is *omitted*.
   An explicit `null` is a value.
3. **Fix.** In the module's `variable "retention_days"` add `nullable = false`. A non-nullable variable
   treats a `null` argument as "use the default".
4. **Verify.** `terraform output effective_retention` → `30`. `terraform plan -var retention_override=7`
   shows `7`.
