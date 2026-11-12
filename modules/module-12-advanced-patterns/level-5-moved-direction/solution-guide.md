# Walkthrough: Seal Moves Backwards

1. **Run the plan.**
   ```
   Error: Moved object still exists
   This statement declares a move from tls_private_key.abbot_seal, but that resource is still declared at main.tf:...
   ```
   The `from` address is still declared as a resource, so Terraform says the object cannot have moved
   away from a place it is still living in.
2. **Think in time order.** `from` = where the object is recorded today (old name `seal`),
   `to` = where the code now says it lives (`abbot_seal`).
3. **Swap them.**
   ```hcl
   moved {
     from = tls_private_key.seal
     to   = tls_private_key.abbot_seal
   }
   ```
4. **Plan.** `tls_private_key.seal has moved to tls_private_key.abbot_seal` and `0 to add, 0 to change, 0 to destroy`.
   Apply, then `check`.
