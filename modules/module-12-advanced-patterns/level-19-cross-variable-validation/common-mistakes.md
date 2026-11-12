# Common mistakes

- **Using `<` instead of `<=`.** A full house of 30 guests at 5 tables of 6 would be rejected; the validator probes
  that boundary.
- **Validating `tables` instead of `guests`.** It works, but then the error blames the wrong variable and a caller who
  only passes `-var guests=...` is told to change something they did not touch.
- **Keeping the precondition as well.** The rule would be enforced twice and the late error still shows up for
  inputs the variables did not catch.
- **Validating inside a `locals` block.** Locals cannot reject anything; only `validation`, `precondition` and
  `check` can.
