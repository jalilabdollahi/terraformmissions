# Solution guide

1. `terraform validate` (or `plan`) fails with `Conflicting configuration arguments`, pointing at
   `content_base64` in `local_file.closed_badge` and saying it conflicts with `content`.
2. Decide which one is right. The badge is a PNG, which is binary data, so `content_base64` is the
   one that decodes the string to bytes before writing. `content` would write the literal base64 text.
3. Remove the `content = local.closed_badge_png` line.
4. `terraform apply`, then `file signage/lift-closed.png` should say `PNG image data, 1 x 1`.
