# Common mistakes

- **Hard-coding `[0]` everywhere.** The plan passes, but only the first chapter is on the contents
  page; the validator checks the total of all chapters and a different list.
- **Reducing `count` to fix the index error.** That drops the last chapter silently instead of
  fixing the off-by-one.
- **Removing `count` and listing three data blocks.** Works for exactly three chapters; the
  mission requires the contents page to follow `var.galleys`.
- **Using `data.local_file.galley.*.content` or similar legacy splat on a single `for` result.**
  Either use the `[*]` splat or a `for` expression; mixing them gives type errors.
