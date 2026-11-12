# Common mistakes

- **Changing the module's variable to `type = string`.** The call is now accepted, but `max()` cannot take a string and
  the mission requires the module's list(number) contract to stay.
- **Turning the root variable into a list.** The operator types text, and the validator passes `-var gusts="15,40"`.
- **Wrapping the string in brackets: `[var.gusts]`.** That is a one-element list containing the whole text, which
  does not convert to a number.
- **Splitting on `", "` or `" "`.** The default has no spaces, so nothing splits and the conversion fails.
