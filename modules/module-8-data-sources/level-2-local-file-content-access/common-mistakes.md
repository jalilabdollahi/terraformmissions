# Common Mistakes

- **Using `content_base64` for text** — always prefer `content` for human-readable files.
- **Using `content` for binary** — binary data may contain bytes that are not valid UTF-8; use `content_base64` instead.
- **Forgetting that `content` includes the trailing newline** — strip it with `trimspace()` if needed.