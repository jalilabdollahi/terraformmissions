# Debrief — indexes live and die with the data

Terraform lists are zero-indexed and strictly bounds-checked. Asking for an element that is not there is
a hard error at plan time, not a silent `null` as in some scripting languages. That is a gift: the
mistake shows up in a review, not on a gate board at 5 p.m. on a Friday.

The error here came from a human counting wrong, but the deeper issue is that `[4]` encodes an
assumption about the data ("there are always five entry slots"). The moment the summer timetable has
three, the same expression breaks again. Expressing the position relative to the data —
`length(list) - 1`, or `element(list, -1)` — keeps the code correct for every list length.

Note the differences:
- `list[n]` errors if `n` is out of range.
- `element(list, n)` wraps around (modulo the length), which is handy for round-robin assignment but
  can mask off-by-one mistakes.
- `try(list[n], "default")` and `one()`/`lookup()` can supply fallbacks when empty lists are legal.

## Real-world takeaway

Anywhere you see a literal index in a configuration, ask what happens when the input has a different
size. Prefer `for` expressions, `length()` and `element()` over magic numbers, and test with odd input:
empty list, single item, longer list. If an empty list is legal, `var.x[length(var.x) - 1]` will fail
with index `-1`, so guard it with a `length(...) > 0` check or a `validation` block on the variable.
