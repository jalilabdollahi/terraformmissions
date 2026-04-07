# Common Mistakes

- **Mixing `content` and `content_base64`** — only one may be set at a time.
- **Forgetting `source`** — if you already have a file on disk, use `source` instead of reading it yourself.
- **Confusing base64 encoding with encryption** — base64 is encoding, not encryption; sensitive data must still be handled carefully.