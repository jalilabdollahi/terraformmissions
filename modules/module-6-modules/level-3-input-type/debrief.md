# Debrief — types are checked at the module boundary

Every module input is validated against the variable's `type` constraint when the module is entered. Terraform
applies *automatic conversions* where they are lossless and obvious: the string `"28"` becomes the number 28,
a tuple becomes a list, an object with the right attributes becomes a map. It will not invent structure. A
string is not a list however comma-shaped it looks, so the call fails with "Inappropriate value".

This is a feature. The module author wrote `list(number)` so that `max(var.gusts_kmh...)` can trust its
argument. If the caller sends a string, only the caller knows how its text should be parsed: split on a comma,
on whitespace, or by decoding JSON with `jsondecode`. That is why the fix belongs at the call site, as an
explicit conversion function, and not in a loosened module type.

Compare the two possible repairs. Changing the child to `string` pushes parsing into the module and makes
every other caller worse off. Converting in the root keeps the interface strict and the transformation
visible in code review.

Remember that conversion is element-wise: `split` returns `list(string)`, and Terraform converts each element to
a number when the variable is `list(number)`. A reading like `"12;18"` would fail at that moment, with an error
that names the module variable, not your `split`.

**Takeaway:** when a module rejects a value, read the declared type in the child, then convert explicitly in
the caller with `split`, `tolist`, `jsondecode` or a `for` expression.
