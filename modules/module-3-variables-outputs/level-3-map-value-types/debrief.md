# Debrief — a type constraint is a schema

`map(string)` reads as "keys are names, every value is a string". The farm's data is richer: each
silkworm carries a number and a string. Terraform's collection types (`list`, `map`, `set`) require
**one** element type; when the elements are structured, that element type is an `object({...})` with
named attributes.

You might be tempted to relax the type to `any`. It makes the error vanish, but you lose what the
constraint was giving you: with `days = number`, a typo like `days = "soon"` is rejected at plan time
with a clear message instead of failing three expressions later inside `max()`.

Differences worth remembering:
- `map(object({...}))`: arbitrary keys, identical value shape — perfect for `for_each`.
- `object({...})` alone: fixed keys, each with its own type.
- `map(any)` / `any`: Terraform infers the type from the value; flexible, but gives weak validation.

## Real-world takeaway

Copying a type constraint from an older version of a file is an easy way to introduce this bug.
Whenever the shape of your data changes, change the constraint in the same commit. When you design
module inputs, prefer `map(object(...))` for "collection of things with properties": the module's
callers get an exact error message pointing to the attribute they got wrong, and documentation
generators can print the full structure.
