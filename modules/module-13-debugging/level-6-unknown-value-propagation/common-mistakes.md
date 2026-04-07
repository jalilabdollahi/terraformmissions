# Common Mistakes

- **Using computed resource attributes in `count` or `for_each`** — these must be statically known.
- **Using `random_*` results as keys or counts** — random values are always unknown at plan time.
- **Confusing `length(list_variable)` (ok) with `length(resource.attr)` (may not be ok)** — it depends on whether the attribute is known at plan time.