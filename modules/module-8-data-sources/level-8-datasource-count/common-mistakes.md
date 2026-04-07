# Common Mistakes

- **Off-by-one** — `count = 3` means valid indices are 0, 1, 2. Index 3 does not exist.
- **Using count where for_each fits better** — if you have a set of named items, `for_each` is more readable.
- **Splat operator misuse** — `data.local_file.configs[*].content` returns a list of all contents.