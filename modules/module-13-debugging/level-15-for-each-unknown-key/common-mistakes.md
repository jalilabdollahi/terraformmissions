# Common Mistakes

- **Using computed resource attributes as for_each keys** — random, UUID, computed IDs are always unknown.
- **Using `count` to work around this** — valid, but then you lose for_each's stable addressing.
- **Confusing known-at-plan-time with known-at-init-time** — variables are always known at plan time.