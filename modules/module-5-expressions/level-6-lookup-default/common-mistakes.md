# Common mistakes

- **Adding low_salt and gluten_free to `batch_kg`.** The plan passes, but every future diet needs
  another edit, and the mission wants a general fallback.
- **Using `lookup(var.batch_kg, diet)` with no default.** It still errors for unknown keys.
- **Hard-coding `3` as the default.** The default setting passes, but changing
  `standard_batch_kg` has no effect.
- **Filtering the diet list down to known diets.** The whiteboard then silently omits low_salt.
- **Wrapping the whole `for` in `try()`.** It hides the failure and returns an empty map.
