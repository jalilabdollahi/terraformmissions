# Debrief - each.value can be a whole object

`for_each` over a plain set gives you strings. `for_each` over a **map of objects** gives you a key and a
structured value, which is where real configurations live: a subnet has a CIDR and a zone, a user has
a name and a role, a pickup slot has a volunteer, a box count and a time. In the loop,
`each.value.boxes` reads one attribute, and Terraform type-checks it against the variable's
`object({...})` declaration.

String interpolation (`"${...}"`) only accepts primitive values: string, number, bool. Pass it an object
and Terraform refuses with a precise message instead of printing something like `{...}`. That strictness is
a gift: you find out at plan time rather than reading a malformed slip in the morning.

## Design notes

- Declare the object type in the variable. Callers get an error if they forget `time`, and your code can
  rely on every attribute being present. Use `optional()` for attributes that may be missing.
- Keep keys for identity (slot names) and put everything else in the object. Then the filename comes
  from `each.key` and the data from `each.value`.
- The same `each.value.x` syntax works in `dynamic` blocks, modules (`module` with `for_each`) and
  `for` expressions, so this skill carries a long way.

## Real-world takeaway

A single variable like `map(object({...}))` replaces several parallel lists that must be kept in step
(names, sizes, zones). The validator planned with a brand-new slot to prove the values come from the
object attributes rather than from the defaults, and it compared whole file contents for all three.
