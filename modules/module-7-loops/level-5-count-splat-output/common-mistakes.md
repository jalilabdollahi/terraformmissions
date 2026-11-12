# Common mistakes

- **Wrapping the single value in brackets: `[local_file.closure[0].filename]`.** It is a list now, but
  with exactly one entry no matter how many shoots registered.
- **Hard-coding `closure[0]`, `closure[1]`, `closure[2]`, `closure[3]`.** Four shoots work; six don't, and
  zero crashes the plan.
- **Changing `closure_count` instead.** That output was already right - the paths output is the problem.
- **Using `join(",", ...)` to make a string.** The portal wants a list, and the validator checks the
  type.
