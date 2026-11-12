# Walkthrough — Quill & Kettle

1. **Diagnose.** `terraform plan` stops with `Invalid value for input variable ... element 0: attribute "size" is required.`
   The source is `terraform.tfvars`, the first entry (espresso) has no `size`.
2. **Two ways to fail:** editing the data (adding `size` to every drink) works once, but the next
   person who adds a drink will hit the same error.
3. **Fix it in the type.** In `variables.tf`:
   ```hcl
   size = optional(string, "regular")
   ```
4. **Verify.** `terraform apply`; `terraform output menu` shows espresso and chai latte with
   `size = "regular"`, and the two large drinks keep `large`.
