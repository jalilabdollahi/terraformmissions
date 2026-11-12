# Common mistakes

- **Creating an empty `tuning/principal-8.txt`.** The plan passes the read, but the regex finds no
  `pipes:` line and fails, and in any case the real sheet is elsewhere.
- **Hard-coding `56` and `"Principal 8'"` in locals.** The outputs look right today, but the sheet is
  no longer the source of truth, and the validator edits the sheet to prove it.
- **Switching the data source to a `resource "local_file"`.** A resource would *write* the file at
  that path instead of reading the existing one.
- **Using an absolute path from your own machine.** It breaks for everyone else and in CI; use
  `path.module`.
