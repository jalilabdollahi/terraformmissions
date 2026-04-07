# Common Mistakes

- **`"true"` vs `true`** — quoted strings are never booleans; use unquoted `true`/`false`.
- **Forgetting `%{endif}`** — every `%{if}` must have a matching `%{endif}`.
- **Whitespace in directives** — use `~` to trim surrounding whitespace: `%{if cond~}...%{~endif}`.