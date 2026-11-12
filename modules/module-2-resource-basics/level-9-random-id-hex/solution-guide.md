# Solution guide

1. `terraform apply` and `terraform output batch_tag`: something like `Q3x-9_aZk0TnPb7u`. 12 random bytes in
   base64url make 16 characters, with capitals, dashes and underscores.
2. `random_id` exports `hex`, `b64_url`, `b64_std` and `dec` for the same bytes. Hex gives two characters per byte.
3. Change `.b64_url` to `.hex` in the file name, in the content and in the output (three places).
4. Pick `byte_length = 6` so the hex string has 12 characters. (`byte_length = 12` would give 24.)
5. `terraform apply`; the old logbook file is removed and a new one with the hex tag takes its place.
