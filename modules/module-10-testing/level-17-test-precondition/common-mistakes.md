# Common Mistakes

- **Targeting the resource when the check is on a variable** — common for validation failures.
- **Targeting the wrong resource** — if there are multiple resources, pick the one with the check.
- **Using the output name for a resource postcondition** — the target is the resource, not the
  output that reads from it.