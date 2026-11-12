# Common mistakes

- **Using `merge()` or `distinct()` to dodge the duplicate key error.** The `for` still produces
  duplicate keys; the right tool is grouping mode.
- **Putting `...` in the wrong place.** It follows the value expression (`tool.id...`), before the
  `if`, not after the condition.
- **Dropping the `if` filter and filtering at output time.** It shows tools that are not serviceable;
  the validator checks the exact lists.
- **Hard-coding the id lists.** The register is edited by the validator and the lists must follow.
- **Using `lookup(tool, "state", "")` to silence the attribute error.** It makes the filter match
  nothing, so every list ends up empty.
