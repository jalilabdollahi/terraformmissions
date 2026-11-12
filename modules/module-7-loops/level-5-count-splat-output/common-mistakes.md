# Common mistakes

- **Wrapping the single value in brackets: `[local_file.permit[0].filename]`.** It is a list now, but
  with exactly one entry no matter how many trucks registered.
- **Hard-coding `permit[0]`, `permit[1]`, `permit[2]`, `permit[3]`.** Four trucks work; six don't, and
  zero crashes the plan.
- **Changing `permit_count` instead.** That output was already right - the paths output is the problem.
- **Using `join(",", ...)` to make a string.** The portal wants a list, and the validator checks the
  type.
