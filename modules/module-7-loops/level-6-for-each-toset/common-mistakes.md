# Common mistakes

- **Switching the variable to `type = set(string)`.** It works, but the mission keeps the list a caller
  can write with duplicates; the fix is the conversion at the `for_each`.
- **Going back to `count = length(var.spices)`.** The duplicate saffron produces two instances writing
  the same file, and addresses are positions rather than names.
- **Using `tolist()` or `tomap()`.** A list is still rejected; a map needs keys the list does not have.
- **Wrapping with `[for s in var.spices : s]`.** A `for` expression in brackets yields another list.
