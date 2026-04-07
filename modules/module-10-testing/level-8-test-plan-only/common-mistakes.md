# Common Mistakes

- **Using `plan` to assert computed IDs or ARNs** — these are only known after apply.
- **Using `apply` for every test** — prefer `plan` when you only need structural validation;
  it is faster and does not create real resources.
- **Expecting `plan` assertions on `count` or `for_each` expansions** — these can also be
  unknown during plan if they depend on computed values.