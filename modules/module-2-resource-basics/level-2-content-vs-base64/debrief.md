# Debrief: text content versus bytes

`local_file` accepts four ways of supplying data: `content`, `sensitive_content` (deprecated),
`content_base64` and `source`. Exactly one may be used. Terraform enforces this at validation time
with `ConflictsWith`, which is why you get the error before any file is touched.

The difference matters for anything that is not UTF-8 text. `content` writes the string as-is. If you
had kept `content` and dropped `content_base64`, the file would be a text file full of
`iVBORw0KGgo...`, and the signage controller would reject it. `content_base64` decodes first and
writes raw bytes, so the PNG magic number `\x89PNG` ends up at the start of the file.

Real-world uses: small icons or certificates embedded in a config, binary blobs fetched through
`filebase64()` and re-written elsewhere, and `gzipbase64()` payloads for cloud-init. The read-side twin
is `filebase64("path")`. Also note the exported `content_sha256`: it hashes the bytes that were
actually written, which makes it a handy output for checking that a binary landed intact.
