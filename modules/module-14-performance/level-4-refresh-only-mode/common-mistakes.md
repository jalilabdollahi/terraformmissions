# Common Mistakes

- **Forgetting lifecycle on tokens/secrets** — any keeper change forces recreation without it.
- **Confusing -refresh-only with terraform refresh** — `terraform refresh` is deprecated; use `-refresh-only`.
- **Not reviewing the refresh-only plan** — always review what drift will be accepted before applying.
- **Using -refresh-only instead of fixing drift** — it accepts drift into state; still update config to match reality.