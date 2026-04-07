# Common Mistakes

- **Wrong resource label in `to`** — must exactly match the declared label.
- **Importing into a resource that's already in state** — results in a conflict; use `terraform state show` to check first.
- **Confusing the `to` address with the actual resource ID** — `to` is the Terraform address; `id` is the provider-side identifier.