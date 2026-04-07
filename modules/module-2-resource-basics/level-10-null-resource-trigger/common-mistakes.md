# Common Mistakes

- **Using unquoted numbers in `map(string)`** — always quote numbers when used as map values.
- **Using `timestamp()` as a trigger carelessly** — this forces replacement on every single plan.
- **Expecting `null_resource` to produce meaningful outputs** — it has no computed attributes besides `id` and `triggers`.