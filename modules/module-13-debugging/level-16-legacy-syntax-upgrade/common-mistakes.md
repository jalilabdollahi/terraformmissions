# Common mistakes

- **Fixing only the errors.** Validate passes but still prints warnings; the mission requires none.
- **Turning every `${...}` into plain text.** Interpolation is still required inside longer strings such as the programme text.
- **Replacing `list("a","b")` with `tolist("a","b")`.** `tolist` takes a single collection argument; write `["a", "b"]`.
- **Changing the outputs' types** while editing (for example making `stall_count` a string). The values must stay a number and a list.
- **Quoting the keys of the map** inconsistently: `"face painting" = 5` needs quotes (it has a space), `tombola = 2` does not.
