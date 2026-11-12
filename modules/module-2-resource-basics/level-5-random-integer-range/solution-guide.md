# Solution guide

1. `terraform validate` and `plan` look fine, but `terraform apply` stops with `Create Random Integer Error` on
   `random_integer.winning_ticket`: `The minimum (minVal) value needs to be smaller than or equal to maximum`.
2. The locals are right (`first_ticket = 1000`, `last_ticket = 1499`) but they are wired to the wrong arguments.
3. Swap them: `min = local.first_ticket`, `max = local.last_ticket`.
4. `terraform apply` and check `terraform output winning_ticket` is between 1000 and 1499.
