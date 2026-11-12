# Common mistakes

- **Hard-coding `[0]` everywhere.** The plan passes, but only the first piece is on the contents
  page; the validator checks the total of all pieces and a different list.
- **Reducing `count` to fix the index error.** That drops the last piece silently instead of
  fixing the off-by-one.
- **Removing `count` and listing three data blocks.** Works for exactly three pieces; the
  mission requires the contents page to follow `var.scores`.
- **Using `data.local_file.score.*.content` or similar legacy splat on a single `for` result.**
  Either use the `[*]` splat or a `for` expression; mixing them gives type errors.
