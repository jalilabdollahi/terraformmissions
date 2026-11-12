# Walkthrough — Acetaia Bruna vinegar loft

1. **Notice the gap.** `terraform plan -var ageing_days=28` succeeds and would publish
   `Modena Reserve, aged 28 days`. Nothing enforces the ageing rule from the comment.
2. **Choose the right guard.** A variable `validation` can only look at that one variable. The rule is
   about *publishing* a value, so attach it to the output: `precondition` blocks are allowed in
   `output` blocks and are evaluated whenever the output is.
3. **Fix.**
   ```hcl
   output "shop_label" {
     value = local.label
     precondition {
       condition     = var.ageing_days >= var.min_ageing_days
       error_message = "Refusing to publish: ..."
     }
   }
   ```
4. **Verify.** `terraform plan -var ageing_days=28` now fails with
   `Module output value precondition failed`; 60 days passes.
