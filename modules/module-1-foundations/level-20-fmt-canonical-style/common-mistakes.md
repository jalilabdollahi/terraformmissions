# Common mistakes

- **Running `terraform fmt` without `-recursive`.** The root files are fixed but `extras/depot-notes.tf` still
  fails the gate.
- **Deleting the unformatted file in `extras/`.** CI goes green, but the depot notes are lost; the mission keeps them.
- **Running only `terraform fmt -check`.** It reports problems but never fixes them.
- **Reformatting by hand and missing the alignment of `=`.** The formatter aligns equals signs of adjacent
  single-line attributes; it is much faster to let the tool do it.
