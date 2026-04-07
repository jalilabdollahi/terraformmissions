# Common Mistakes

- **Using computed values as for_each keys** — only static/input values work as keys.
- **Same restriction applies to count** — `count` must also be known at plan time.