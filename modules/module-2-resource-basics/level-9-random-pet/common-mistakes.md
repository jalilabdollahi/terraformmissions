# Common Mistakes

- **Forgetting quotes around string values** — `separator = -` (bare) and `separator = 123` (number) are both wrong.
- **Single quotes** — HCL only accepts double quotes for string literals.
- **Confusing `length` (number) with `separator` (string)** — each attribute has a defined type; check the docs.