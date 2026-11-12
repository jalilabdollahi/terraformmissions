# Walkthrough — Frosty Spoon

1. **Diagnose.** `terraform plan` stops with `Invalid value for input variable ... element 0: attribute "size" is required.`
   The source is `terraform.tfvars`, the first entry (vanilla) has no `size`.
2. **Two ways to fail:** editing the data (adding `size` to every flavour) works once, but the next
   person who adds a flavour will hit the same error.
3. **Fix it in the type.** In `variables.tf`:
   ```hcl
   size = optional(string, "regular")
   ```
4. **Verify.** `terraform apply`; `terraform output menu` shows vanilla and salted caramel with
   `size = "regular"`, and the two large flavours keep `large`.
