# Common mistakes

- **Making the lift list a string in both branches.** `join()` of a string fails, and the output is
  no longer a list.
- **Returning `null` for non-juniors and multiplying.** `80 * null` is an error.
- **Quoting the numbers.** `"0.5" : "1"` makes the factor a string; the check requires JSON numbers.
- **Testing only the default flags.** Adults and the off-season lift list are only exercised when you
  flip `junior` and `peak_season` yourself.
- **Deleting the conditionals and hard-coding the peak-season, adult case.** The check flips both
  flags and expects the other combinations to work.
