# Debrief — for_each makes module.x a map; collect it with for

`count` turns a module call into a list, and the splat `[*]` was designed for lists. `for_each` turns it into a map (really
an object) keyed by the instance keys. A splat cannot reach through the values of a map, which is why `module.classroom[*].minutes`
fails with an unsupported-attribute error that mentions an object with four attributes.

The tool for maps is the `for` expression. `{ for style, m in module.classroom : style => m.minutes }` rebuilds a map that
keeps the instance keys, so callers can still look up `prep_minutes["hatha"]`. `[for m in module.classroom : m.minutes]`
discards the keys when you only need the values, for example to `sum()`, `max()` or `join()` them. The order of iteration
for maps is lexical by key, so lists built this way are stable between runs.

This is the standard recipe for aggregating a `for_each` module: build a map for lookups, and derive any totals or
lists from it. If you need to filter instances, add an `if` clause: `{ for k, m in module.classroom : k => m.minutes if m.minutes > 40 }`.

Choosing between `count` and `for_each` has consequences all the way to the output expressions: lists need splats and
numeric indexes; maps need `for` expressions and string keys. Pick the one that matches the identity of the things you create.

**Takeaway:** for `for_each` modules, collect outputs with a `for` expression keyed by the instance key, and derive
totals from that.
