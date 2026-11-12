# Common mistakes

- **Switching to `t.staffed == 1` or `t.staffed != "false"`.** Still a cross-type comparison; the
  filter keeps the wrong towers or none at all.
- **Fixing only the boolean.** Tamarack, exactly 25 m, is still missing because of the strict `>`.
- **Lowering `min_height_m` to 24.99.** The default roster is right but the threshold is not the
  variable's value any more.
- **Replacing the filter by deleting towers from the variable.** The check supplies a different set.
- **Using `||` instead of `&&`.** Unstaffed Old Hollow (40 m) joins the roster.
