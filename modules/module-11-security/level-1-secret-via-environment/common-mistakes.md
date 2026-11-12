# Common mistakes

- **Quoting the password in the command (`--password '${var.landing_password}'`).** Quotes only change how the shell
  parses the line; the process still has the secret in argv.
- **Writing the password into a file and passing `--password-file`.** Better, but now you have a plaintext secret on disk;
  this mission asks for the environment variable the script already reads.
- **Marking the variable `sensitive` and calling it done.** It already was. `sensitive` redacts Terraform's own output; it does not
  change what a child process receives.
- **Using `nonsensitive()` or a `locals` indirection.** The value is still interpolated into the same string.
