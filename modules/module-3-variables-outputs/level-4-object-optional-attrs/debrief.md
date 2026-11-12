# Debrief — optional attributes with defaults

An `object({...})` type constraint is strict: every attribute you list is required, and unknown
attributes are discarded. That strictness is useful (it catches typos like `pirce`) but a menu where
"most drinks come in one size" needs a way to say "you may leave this out".

`optional(type, default)` does that. It was an experimental feature for a long time and has been stable
since Terraform 1.3. Without the second argument the missing attribute becomes `null`; with it,
Terraform fills the default **during type conversion**, so every place that reads `d.size` sees a
complete object. That also means the default applies to values from tfvars, from `-var`, and from a
calling module — the one place to keep it is the variable declaration.

The common alternative, `try(d.size, "regular")` or `lookup(d, "size", "regular")` in every expression,
needs the variable to be typed loosely (`any`), pushes the default into the consumers and gets copied
and forgotten. Defaults belong to the interface.

## Real-world takeaway

When you design a module input as a list of objects, decide for each attribute: required, optional with
a sensible default, or optional with `null` meaning "not set". Document it in the `description`. Callers
get a precise error when they omit something required, and are not forced to repeat boilerplate for
things that rarely change.
