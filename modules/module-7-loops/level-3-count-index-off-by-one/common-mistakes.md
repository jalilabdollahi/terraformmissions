# Common Mistakes

- **One-based indices** — `count = 3` gives indices 0, 1, 2 — never 1, 2, 3.
- **Hardcoding indices** — prefer `[*]` splat over listing `[0]`, `[1]`, `[2]` individually.