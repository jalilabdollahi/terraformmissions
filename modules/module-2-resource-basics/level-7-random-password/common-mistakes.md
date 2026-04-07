# Common Mistakes

- **Not accounting for all `min_*` fields when setting `length`** — add them all up before choosing a length.
- **Forgetting `min_special`** — if `special = true` (default), also include `min_special` in the sum.
- **Outputting `random_password.result` without `sensitive = true`** — the result is marked sensitive and should stay that way.