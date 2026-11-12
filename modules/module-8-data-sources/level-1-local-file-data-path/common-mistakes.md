# Common mistakes

- **Creating an empty `tuning/tenor-lead.txt`.** The plan passes the read, but the regex finds no
  `notes:` line and fails, and in any case the real sheet is elsewhere.
- **Hard-coding `29` and `"Tenor Lead"` in locals.** The outputs look right today, but the sheet is
  no longer the source of truth, and the validator edits the sheet to prove it.
- **Switching the data source to a `resource "local_file"`.** A resource would *write* the file at
  that path instead of reading the existing one.
- **Using an absolute path from your own machine.** It breaks for everyone else and in CI; use
  `path.module`.
