# Common mistakes

- **Using `concat()` on the outer result.** `concat` expects separate list arguments; without
  expansion it errors, and with `...` on the wrong value it only flattens one level by accident.
- **Keying the map by list index.** It runs, but the keys no longer match the validator's addresses
  and every address shifts when the programme changes.
- **Deleting the Screen Two or Vault entries to dodge the error.** Six stubs are required.
- **Hard-coding six `local_file` resources.** The second programme in the check has different shows.
- **Keying only by film title.** Two screens can play the same film, giving a duplicate key error.
