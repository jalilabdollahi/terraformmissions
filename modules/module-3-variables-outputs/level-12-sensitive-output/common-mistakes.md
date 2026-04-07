# Common Mistakes

- **`sensitive = "true"` (quoted)** — always use unquoted `true` or `false`.
- **Thinking `sensitive = true` encrypts the state** — it only masks the output; state remains plaintext.
- **Forgetting `sensitive` on outputs that expose secret variables** — if the input is sensitive, the output should be too.