# Solution guide

1. `terraform plan` fails on `random_password.guest_wifi` with a message that the sum of the minimum
   character counts is greater than the length.
2. Add the four minimums: `min_upper (4) + min_lower (4) + min_numeric (3) + min_special (3) = 14`, but
   `length = 12`.
3. The policy still wants at least 2 of each class, and length must stay at 12. Reduce the minimums so
   the sum is at most 12, for example 3 + 3 + 3 + 2 = 11.
4. `terraform apply`, then `terraform output -raw guest_wifi_password` prints the new password (the
   output is sensitive, so plain `terraform output` hides it).
