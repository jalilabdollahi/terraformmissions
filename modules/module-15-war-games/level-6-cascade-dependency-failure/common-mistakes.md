# Common Mistakes

- **Trying to fix downstream modules first** — the root cause is always in the leaf module.
- **Using .id instead of .result on random resources** — a recurring mistake; always check the provider schema.
- **Not testing modules in isolation** — cascade failures are caught early if each module is tested independently.
- **Complex dependency chains without documentation** — document the A → B → C flow so debugging is faster.