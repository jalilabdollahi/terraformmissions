# Common mistakes

- **Adding okapi and capybara to `rations_kg`.** The plan passes, but every future animal needs
  another edit, and the mission wants a general fallback.
- **Using `lookup(var.rations_kg, animal)` with no default.** It still errors for unknown keys.
- **Hard-coding `3` as the default.** The default setting passes, but changing
  `standard_ration_kg` has no effect.
- **Filtering the animal list down to known species.** The whiteboard then silently omits the okapi.
- **Wrapping the whole `for` in `try()`.** It hides the failure and returns an empty map.
