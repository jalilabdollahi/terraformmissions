# Common Mistakes

- **Using `local_file` for secrets** — prefer `local_sensitive_file` so content is masked in plan output.
- **Using string `"600"` instead of octal `"0600"`** — always include the leading zero for octal notation.
- **Setting `0777` permissions on secret files** — this makes them world-readable by all users.