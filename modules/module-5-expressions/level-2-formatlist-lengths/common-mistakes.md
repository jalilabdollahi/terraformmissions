# Common mistakes

- **Adding a third `"GBP"` to the hand-typed list.** The plan passes for three tiers and breaks again
  as soon as a fourth tier appears; the currency variable is also ignored.
- **Wrapping the variable as `[var.currency]`.** It looks tidy, but a one-element list is still a list,
  and its length of 1 does not match 3 tiers. Only non-list values are repeated.
- **Replacing `formatlist()` with `format()` in a loop of copied lines.** The output is right for the
  defaults but is no longer driven by the tiers list.
- **Truncating `var.tiers` to two entries.** The plan runs, but Gallery vanishes from the board.
