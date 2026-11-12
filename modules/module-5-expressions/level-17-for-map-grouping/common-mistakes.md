# Common mistakes

- **Making the key unique with the flight number.** There would be one board per flight, not one per
  carousel; the objective wants exactly three files.
- **Putting the dots after the key.** The ellipsis goes at the end of the value expression.
- **Using `distinct()` on the carousel keys to remove the duplicates.** The error disappears, but the
  flights from the second and third arrival are lost.
- **Joining with a literal string, `a.flight + a.flight`.** Strings do not add up in HCL; use grouping.
- **Forgetting that values are now lists.** If you also change `join()` to `each.value` the board
  prints `["SB204", ...]` style errors.
