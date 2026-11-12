# Common mistakes

- **Writing `module.snack_bar[0].menu_path`.** It plans while open, but plan with the bar closed fails
  with "Invalid index" - the validator toggles the flag.
- **Removing `count` from the module call.** The module is always on, so there is no closed state, and the mission
  keeps the toggle.
- **Wrapping everything in `try(..., "")`.** An empty string is not the null / empty list the outputs are
  meant to return, and it hides real errors.
- **Using `module.snack_bar.*.menu_path`.** The legacy splat gives a list, not the single string `menu_path`
  should be.
