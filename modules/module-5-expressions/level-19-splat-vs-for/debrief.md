# Debrief — splat is a list tool

The splat operator `[*]` (and the older `.*`) is shorthand for a simple `for` expression:
`var.crew[*].name` means `[for c in var.crew : c.name]`. It is concise, but it only knows about lists,
sets and tuples.

On a map or object Terraform does something else: it treats the single value as a one-element list.
So `var.cast[*].puppeteer` asks the map itself for an attribute named `puppeteer`, which does not
exist. The error is confusing, since the attribute is plainly present in every value. The map has
roles for keys, not puppeteers.

Two ways to loop over a map:

- a `for` expression: `[for role, c in var.cast : c.puppeteer]`, which also lets you filter and
  reshape,
- `values(var.cast)[*].puppeteer`, when you only need the values as a list.

Either way, remember that map iteration order is by key, which is why dragon comes first even though
queen was typed first.

The one-element wrapping, an irritation on a map, is a feature for optional values: if the thing is
null the splat returns `[]`, otherwise `[value]`. That is why `var.understudy[*].name` is the tidy way to
write "the understudy's name if there is one" and why it should stay.

## Real-world takeaway

Use splat for attributes of `count`-created resources and plain lists; use `for` when you iterate a
map such as one made by `for_each`, e.g. `[for k, r in aws_instance.web : r.id]`. Reach for
`values()` when a one-liner is enough.
