# Common mistakes

- **Adding fjord and haflinger to `rations_kg`.** The plan passes, but every future horse needs
  another edit, and the mission wants a general fallback.
- **Using `lookup(var.rations_kg, horse)` with no default.** It still errors for unknown keys.
- **Hard-coding `3` as the default.** The default setting passes, but changing
  `standard_ration_kg` has no effect.
- **Filtering the horse list down to known breeds.** The whiteboard then silently omits the fjord.
- **Wrapping the whole `for` in `try()`.** It hides the failure and returns an empty map.
