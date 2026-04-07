# Common Mistakes

- **Calculated count going negative** — add a `max(0, calculated_value)` guard.
- **Using `-1` as "disable" sentinel** — use `count = 0` to disable a resource.
- **Confusing `count.index` range** — with `count = N`, valid indexes are `0` to `N-1`.