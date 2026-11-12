# Common mistakes

- **Switching to `type = any` or `map(any)`.** Validation passes, but a non-numeric `days` is no longer
  rejected — the check in this mission tries exactly that.
- **Flattening the data into `map(string)` with JSON strings.** You'd have to `jsondecode` everywhere and
  lose type checking.
- **Using `object({ days = number, tray = string })` without `map(...)`.** The default has four keys
  (tomato, basil...), which is a map of objects, not a single object.
- **Deleting two seedlings from the default** until the error goes away. The error is about types, not
  about the amount of data, and the outputs would no longer match.
