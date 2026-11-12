# Debrief — Fenwick Cheese Cellar

**What broke.** Terraform's naming is deliberately asymmetric: you *declare* named values in a `locals`
block (plural, because one block holds many), and you *read* each one as `local.<name>` (singular, like
`var.<name>` for variables). The author wrote `local {` to declare and `locals.cheese` to read. Both are
the mirror image of the rule, and both fail, the first as an unsupported block type, the second as a
reference to an object that does not exist.

**Why locals exist.** A local is a named expression, private to the module. They remove repeated
calculations (`8 * 31` typed in two places is a bug waiting to happen), give meaning to magic numbers, and let
you build values from variables, resources and other locals. Unlike variables, callers cannot override them.

**Computed, not copied.** `wheel_price` was a hard-coded `8 * 31` that merely looked like a formula. If
someone raises `price_per_kg`, the label silently keeps the old price. Referencing the other locals makes
the dependency explicit; Terraform also detects reference cycles between locals, so you cannot create a loop by
accident.

**Real-world takeaway.** Use `variable` for inputs callers should set, `locals` for derived values and
shared naming conventions, and `output` for what callers can read. Remember the pattern: plural to declare,
singular to read.
