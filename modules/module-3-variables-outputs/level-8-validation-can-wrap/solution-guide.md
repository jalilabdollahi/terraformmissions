# Walkthrough — Spoke & Pedal

1. **Reproduce with bad input.** `terraform plan -var release_tag=3.12`. You get
   `Error: Invalid function argument ... pattern did not match any part of the given string`
   instead of the message "Release tags must look like v3.12".
2. **Why.** `regex()` returns the match or *raises an error*. It never returns `false`, so
   `regex(...) != ""` cannot produce a boolean for a non-matching tag.
3. **Fix.** Use `can()` to convert an error into `false`:
   `condition = can(regex("^v[0-9]+\\.[0-9]+$", var.release_tag))`.
4. **Verify.** The same `-var` command now reports `Invalid value for variable` followed by your message.
