# Walkthrough - Storage Unit Lock Codes

1. `terraform test -verbose` fails `code_policy` and `public_label`. For the label, the Diff shows both strings.
   For the code:
   ```
   Warning: Error message refers to sensitive values
   ...
   - "(sensitive value)"
   ```
   Terraform hides any message that touches a sensitive value, and the diff is masked too.
2. Diagnose without leaking the secret. Length is not sensitive information in itself, so unmask only that:
   `error_message = "got ${nonsensitive(length(output.lock_code))} digits"`. The run shows 8.
3. The assertion expects 6, but the policy (and `lock.tf`) say 8: change the test to `== 8`.
4. `public_label` expects `unit a-14`; the real label is `Unit A-14`. Fix the case.
5. `Success! 2 passed, 0 failed.` The output remains sensitive; the test never prints or hard-codes the code.
