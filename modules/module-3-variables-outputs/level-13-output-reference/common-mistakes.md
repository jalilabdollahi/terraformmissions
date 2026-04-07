# Common Mistakes

- **Confusing input arguments with exported attributes** — they are listed separately in provider docs.
- **Trying to read back `content`** — use `content_md5` or `content_sha256` if you need to verify the content.
- **Assuming all inputs are also outputs** — this varies by resource and provider.