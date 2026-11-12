# Common mistakes

- **Changing the variable's type to `set(string)`.** It also works, but the validator passes a JSON list through `-var`, and
  the mission keeps the variable as a list.
- **Switching to `count`.** The instances are then addressed by number and the key lookup `["vase"]` makes no sense.
- **Using `lower("Vase")` in the lookup.** It happens to work but hides that the instance key is just the list entry.
- **Wrapping with `tomap(var.pieces)`.** A list of strings is not a map; `toset` is the right conversion.
