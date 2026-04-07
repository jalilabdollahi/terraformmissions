# Common Mistakes

- **Mixing scalars and lists** — wrap bare values in `[...]` before passing to `flatten`.
- **Expecting flatten to work on maps** — `flatten` only works on lists and tuples.
- **Unnecessary flatten** — if your data is already flat, `flatten` is a no-op but causes confusion.