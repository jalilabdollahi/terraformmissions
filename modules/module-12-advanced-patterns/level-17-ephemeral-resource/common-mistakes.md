# Common mistakes

- **Replacing the ephemeral block with a `tls_private_key` resource.** It plans and applies, but the private
  key is written to the state, which the validator specifically checks.
- **Wrapping the value in `nonsensitive()` or `sensitive()`.** Neither removes the ephemeral mark; the
  error is about persistence, not display.
- **Leaving out `private_key_pem_wo_version`.** The provider requires it next to the write-only argument.
- **Setting the key into a local value first.** A local derived from an ephemeral value is itself ephemeral and gets
  the same rejection on a normal argument.
