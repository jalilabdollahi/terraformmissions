# Common Mistakes

- **Bare newlines inside strings** — not allowed. Use `\n` or a heredoc.
- **Forgetting `<<-` (indented form)** — `<<EOF` requires the closing marker at column 0.
- **Missing newline before closing marker** — the closing marker must be on its own line.