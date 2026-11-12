# Walkthrough — Lumen Stock Photo Agency

1. **Diagnose.** `terraform validate` prints two errors of the form
   `Unsupported attribute ... This object has no argument, nested block, or exported attribute named "path"`
   (and the same for `sha256`), each with the file and line.
2. **Find the real names.** Look up `local_file` in the provider docs, or run
   `terraform providers schema -json | jq '.provider_schemas | to_entries[] | .value.resource_schemas.local_file.block.attributes | keys'`.
   It exports `filename`, `content_md5`, `content_sha1`, `content_sha256`, `content_sha512`, `content_base64sha256` ...
3. **Fix.** `local_file.catalogue.filename` and `local_file.catalogue.content_sha256`.
4. **Verify.** `terraform apply`; `terraform output catalogue_checksum` equals `shasum -a 256 archive/catalogue.csv`.
