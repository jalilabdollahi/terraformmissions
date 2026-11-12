# Debrief — lists are not argument lists

Functions such as `max()`, `min()`, `merge()`, `concat()` and `format()` are **variadic**: they accept
any number of separate arguments. `max(3, 9, 4)` works. A list holding the same numbers does not,
because the function sees a single argument of the wrong type and refuses it.

The expansion symbol `...` bridges the two worlds. Placing it after the final argument of a call
converts a list or tuple into individual arguments, so `max(local.all_depths...)` behaves exactly like
`max(12.5, 48, 31.2, ...)`. It is only valid inside function-call parentheses; anywhere else the
parser rejects it.

Other places where you will use it:

- `merge(var.tag_maps...)` to combine an arbitrary list of maps.
- `concat(local.lists...)` or `setunion(local.sets...)` when the number of inputs is dynamic.
- `zipmap` is NOT variadic and does not need it, which is why the pattern is easy to forget.

Also remember what happens on an empty list: `max([]...)` is an error because there is nothing to
compare. If a list may be empty, guard it with `length()`.

## Real-world takeaway

Whenever the number of inputs comes from data rather than from the code, you will hit variadic
functions. Combine `flatten()` or a `for` expression to build one flat list, then spread it with `...`.
The result stays correct when somebody adds a fourth drill site, which a hand-written `max(a, b, c)`
would silently ignore.
