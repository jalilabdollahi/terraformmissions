# Common mistakes

- **Using `<` instead of `<=`.** A full house of 30 students at 5 benches of 6 would be rejected; the validator probes
  that boundary.
- **Validating `benches` instead of `students`.** It works, but then the error blames the wrong variable and a caller who
  only passes `-var students=...` is told to change something they did not touch.
- **Keeping the precondition as well.** The rule would be enforced twice and the late error still shows up for
  inputs the variables did not catch.
- **Validating inside a `locals` block.** Locals cannot reject anything; only `validation`, `precondition` and
  `check` can.
