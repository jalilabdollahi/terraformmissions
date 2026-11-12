# Common mistakes

- **Running `terraform apply` hoping it will print the values.** Apply shows only what changes; with a clean plan it prints nothing useful. It also risks changing infrastructure.
- **Forgetting the single quotes around a `for_each` address.** `terraform state show random_integer.serial["annex"]` loses its inner quotes in the shell and fails with "index value required" or "no instance found".
- **Copying the `id` instead of `result`, or including quotes.** For `random_pet` the `id` is the value, but it is printed as `"guard-able-wolf"`. The answer file must contain the name without quotes.
- **Adding an output and re-running apply.** It works, but it changes the configuration and plan; the mission only needs read-only commands.
- **Guessing from the registry file.** It deliberately contains no serials.
