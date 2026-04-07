# Common Mistakes

- **Splat on single-instance resource** — add `count` or `for_each` first.
- **Splat on `for_each` resources** — `[*]` doesn't work on maps; use `values(resource)[*].attr`.
- **Using splat when a direct reference suffices** — for a single resource, just use `resource.name.attribute`.