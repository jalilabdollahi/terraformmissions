# Common mistakes

- **Deleting the `alarm_code` output.** It must stay, redacted, for automation that reads it with `-json`.
- **Marking the output sensitive but keeping `nonsensitive()` in the local.** The panel file still prints the code, and the output
  sensitivity is only cosmetic when the file leaks it.
- **Removing `nonsensitive()` and keeping `length()` sensitive.** Then `code_length` and the panel interpolation fail, because
  outputs derived from the secret need a mark. The length is the one value that is safe to unmask.
- **Hard-coding `6` for the length.** The validator uses a different code; the length has to be computed from the variable.
