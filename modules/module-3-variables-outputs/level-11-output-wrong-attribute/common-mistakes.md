# Common mistakes

- **Recomputing the checksum with `sha256(local_file.catalogue.content)`.** The hash matches only if you
  hash exactly what was written; the exported attribute is the right source and the mission checks for it.
- **Using `abspath(...)` or `"${path.module}/archive/catalogue.csv"` for the path output.** It may look right,
  but it duplicates the filename and drifts from the resource when someone renames the file.
- **Deleting the failing outputs.** The partner portal needs them.
- **Guessing `content_sha`** or `sha256sum` — close, but still "Unsupported attribute".
