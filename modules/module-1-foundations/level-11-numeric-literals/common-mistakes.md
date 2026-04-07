# Common Mistakes

- **Quoting numbers** — `length = "16"` works sometimes but is wrong.
- **Quoting booleans** — `special = "false"` is a string, not a boolean.
- **Number in non-numeric context** — don't use bare `16` where a string is expected.