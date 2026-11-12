# Walkthrough — Driftwood Wi-Fi Vouchers

1. **Run `terraform validate`.** It reports the first argument that is not a boolean:
   ```
   Error: Incorrect attribute value type
     on main.tf line 6, in resource "random_string" "wifi_voucher":
   Inappropriate value for attribute "upper": a bool is required.
   ```
   Fix it and run again: `lower`, `numeric` and `special` follow.
2. **Know the rule.** A `bool` argument accepts the literals `true` and `false`. Terraform will also convert
   the *strings* "true" and "false", but nothing else.
3. **Edit.** `upper = true`, `lower = false`, `numeric = true`, `special = false`.
4. **Apply and check.** `terraform output voucher` is 8 characters from A-Z and 0-9.
