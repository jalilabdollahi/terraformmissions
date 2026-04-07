# Common Mistakes

- **Fixing only the resource type but forgetting the output** — both must reference the correct type and name.
- **Partial fixes** — always run `terraform validate` AND `terraform plan` before concluding the fix is complete.
- **Assuming one error equals one fix** — a single wrong resource type can cause multiple downstream errors.