# Common Mistakes

- **Assuming all `random_*` resources use `.result`** — `random_uuid` and `random_pet` use `.id`.
- **Confusing `random_id` with `random_uuid`** — `random_id` provides multiple encoding formats; `random_uuid` only has `.id`.
- **Not checking provider docs** — always verify attribute names before referencing them.