# Common mistakes

- **Removing `sensitive = true` from the variable.** The error vanishes because nothing is sensitive any
  more — and the password is now printed in every plan and apply log.
- **Wrapping the output in `nonsensitive(...)`.** Also makes the error disappear, by publishing the secret
  on purpose.
- **Deleting the output.** The concierge-desk automation needs it, and the validator checks it exists.
- **Thinking `sensitive` hides the value from the state file.** It does not; state still contains the
  plaintext. The flag only redacts CLI output.
