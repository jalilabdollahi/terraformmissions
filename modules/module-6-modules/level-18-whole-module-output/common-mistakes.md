# Common mistakes

- **Typing the three field names into a list.** It works today and silently goes stale when the module gains an output.
- **Building the JSON from three separate references.** The values match, but the board no longer includes new
  outputs automatically, which is the point of using the whole object.
- **Using `tostring(module.busker)`.** Objects cannot be converted to a string; `jsonencode` is the right serialiser.
- **Wrapping in `values()`.** That yields a list of the values without their names.
