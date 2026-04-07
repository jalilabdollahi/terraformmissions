# Common Mistakes

- **Forgetting the key** — `data.local_file.files.content` fails; always include the key.
- **Wrong key type** — the key must match exactly what is in the `for_each` set or map.
- **Using `[*]` splat with `for_each`** — the splat operator only works with `count`-based resources.