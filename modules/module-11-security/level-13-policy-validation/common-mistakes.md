# Common mistakes

- **Adding `::/0` to the blocklist.** One more spelling closed, `0.0.0.0/1` and the empty list still pass. Express the rule as a prefix floor.
- **Checking only `var.allowed_cidrs[0]`.** A bad network in second position slips through.
- **Using a regex on the TLS string, such as `regex("^1\\.[23]$", ...)`, without `can()`.** `regex` errors on no match instead of returning false, giving a confusing failure.
- **Putting the check in a `precondition` on the resource.** It would block the plan too, but the mission is about rejecting the *input*, and the validator expects the 'Invalid value for variable' error.
