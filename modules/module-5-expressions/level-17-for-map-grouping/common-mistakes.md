# Common mistakes

- **Making the key unique with the plate number.** There would be one board per plate, not one per
  belt; the objective wants exactly three files.
- **Putting the dots after the key.** The ellipsis goes at the end of the value expression.
- **Using `distinct()` on the belt keys to remove the duplicates.** The error disappears, but the
  plates from the second and third plate are lost.
- **Joining with a literal string, `a.plate + a.plate`.** Strings do not add up in HCL; use grouping.
- **Forgetting that values are now lists.** If you also change `join()` to `each.value` the board
  prints `["TUNA-1", ...]` style errors.
