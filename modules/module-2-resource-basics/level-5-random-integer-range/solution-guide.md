# Solution guide

1. `terraform validate` and `plan` look fine, but `terraform apply` stops with `Create Random Integer Error` on
   `random_integer.winning_card`: `The minimum (minVal) value needs to be smaller than or equal to maximum`.
2. The locals are right (`first_card = 1000`, `last_card = 1499`) but they are wired to the wrong arguments.
3. Swap them: `min = local.first_card`, `max = local.last_card`.
4. `terraform apply` and check `terraform output winning_card` is between 1000 and 1499.
