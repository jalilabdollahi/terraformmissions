# Common mistakes

- **Putting both checks in the postcondition.** A missing file would then fail inside the read with the
  provider's own error, so the clear message never appears; the validator specifically tests this.
- **Replacing `data.local_file.ladder.content` with `file(...)` in the precondition.** It validates, but `file()` on
  a missing path is itself an error before your message can be shown.
- **Checking only `fileexists`.** The `.txt` copy exists and has valid content, yet it is not an export the
  club accepts.
- **Deleting the guard to make the error go away.** Plans with a bad export would then silently build a
  wrong standings file.
