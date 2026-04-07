# Common Mistakes

- **Using `var.env` in `error_message`** — not allowed; the message must be a literal string.
- **Multiple validation blocks** — you can have multiple `validation` blocks on one variable; each is checked independently.