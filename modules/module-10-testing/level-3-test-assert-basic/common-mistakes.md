# Common Mistakes

- **Copy-pasting placeholder expected values** — always verify what the config actually produces.
- **Using `==` on complex types** — for objects/maps, prefer attribute access or `tostring()`.
- **Forgetting `output.` prefix** — inside a `run` block, outputs are accessed as `output.<name>`.