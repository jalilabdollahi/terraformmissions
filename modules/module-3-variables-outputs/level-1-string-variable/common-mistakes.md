# Common Mistakes

- **Declaring `type = number` for names/labels** — use `string` for text values.
- **Omitting `type` entirely** — without a type, Terraform accepts any value and type errors appear later.
- **Confusing `type` constraint with `validation` block** — `type` checks the data type; `validation` checks the logical value.