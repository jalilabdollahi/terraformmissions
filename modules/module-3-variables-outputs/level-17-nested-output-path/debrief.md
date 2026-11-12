# Debrief — know the path through your data

Nested data is written once and read many times, and every read has to follow the exact path.
Terraform distinguishes two kinds of steps, and the errors differ:

- **Object attribute** (`.enclosure`, `.capacity`) — the names are fixed by the type. A wrong name gives
  `Unsupported attribute`, and Terraform often suggests the closest real one.
- **Map key / list index** (`["savanna"]`, `[0]`) — the keys are *data*. A wrong key gives
  `Invalid index` because that element does not exist in this particular map.

Here each output made a different mistake: a missing level in the path, a singular instead of plural
attribute, and a made-up key. Because the variable has an explicit type, Terraform catches the first
two even before anything runs; the third depends on the keys that are really present.

Useful tools:
- `terraform console`, then `var.habitats` (prints the whole structure) and `keys(var.habitats)`.
- `lookup(map, key, default)` and `try()` when a key may legitimately be missing.
- A `for` expression to project the shape you need once (`{for k, h in var.habitats : k => h.enclosure.capacity}`)
  instead of repeating long paths in every output.

## Real-world takeaway

When a data structure is more than two levels deep, give it a precise type constraint and consider
flattening it into a local that your outputs and resources share. Long ad-hoc paths scattered across
files are where typos hide, and a typed variable turns many of them into plan-time errors.
