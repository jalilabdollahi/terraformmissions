# Common Mistakes

- **Using `timestamp()` in resource content** — it evaluates to a different value each plan.
- **Using `uuid()` similarly** — same problem.
- **Over-using `ignore_changes`** — only ignore fields that are genuinely externally managed.