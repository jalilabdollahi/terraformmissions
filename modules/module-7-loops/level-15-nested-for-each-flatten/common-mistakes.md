# Common Mistakes

- **Forgetting `flatten()`** — nested for expressions always need it when used with `toset()` or `for_each`.
- **Extra brackets** — `toset(flatten([...]))` not `toset([flatten([...])])`.