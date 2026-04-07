# Common Mistakes

- **Setting length = 0** — all random resource lengths must be positive.
- **Exposing state output** — `state pull` shows sensitive values (passwords, keys) in plaintext.
- **Editing state JSON manually** — never edit state directly; use `state mv`, `state rm`, or `state push` for state manipulation.