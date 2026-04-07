# Common Mistakes

- **Mixing print statements with JSON output** — any non-JSON line on stdout breaks parsing.
- **Nested objects** — all values in the result map must be strings; nested objects are not allowed.
- **Not flushing stdout** — in some languages, buffer flushing is needed before exit.
- **Exit code** — always exit with code 0 on success; non-zero is treated as an error.