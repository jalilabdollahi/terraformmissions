# Common Mistakes

- **Using decimal digits in octal strings** — `8` and `9` are not octal digits.
- **Forgetting the leading `0`** — `"644"` is treated as a string but may not work as expected.
- **Panicking on partial apply** — run `terraform apply` again after fixing the error; Terraform handles idempotency.