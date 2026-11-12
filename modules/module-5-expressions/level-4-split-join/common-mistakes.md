# Common mistakes

- **Wrapping the result in `compact()` only.** It removes `""` but not `" "`, and it leaves the
  leading space on `" Mill Ford"`, so Heron Way still looks wrong.
- **Trimming the whole string before splitting.** `trimspace()` on the CSV does not touch the spaces
  around the inner commas.
- **Changing the separator to `", "`.** Now `"Oak Gate,Mill Ford"` no longer splits at all.
- **Special-casing the Quiet Loop by name.** The second input set has other empty-looking trails.
- **Fixing counts but not the join.** The signpost is built from the stops list; if you filter only
  inside the count output, the signposts still contain blanks.
