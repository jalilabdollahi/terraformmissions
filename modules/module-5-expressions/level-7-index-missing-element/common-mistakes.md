# Common mistakes

- **Adding "Michael" to the bell list.** The plan passes, but the tower really has five bells and the
  next unknown name breaks it again.
- **Changing the default `start_bell` to "Gabriel".** The default works, but the validator tries
  other unknown names.
- **Wrapping with `try(index(...), -1)`.** `slice()` rejects a negative start index.
- **Using `length(...)` as the fallback.** The first slice then becomes empty and the order changes.
- **Replacing `index()` with a hand-typed position.** The rotation only works for one start bell.
