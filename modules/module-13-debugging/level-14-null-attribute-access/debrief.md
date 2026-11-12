# Debrief - null is a value, and it propagates errors

In Terraform, a missing optional value is not "empty", it is `null`: a real value that means "absent". Two operations on it are
errors rather than empty results: reading an attribute or index of a null *object* ("Attempt to get attribute from null value"), and
interpolating null into a *string* template. Both appear the first time real data contains a gap, which is why code that passed on the
happy-path sample fails in production.

The standard tools, in order of preference:

- **`try(expr, fallback)`** evaluates the expression and returns the fallback if it raises *any* error, so it covers "claim is null" without
  you having to spell the check out.
- **`coalesce(a, b, ...)`** returns the first argument that is neither null nor an empty string. Be aware it fails when everything is null,
  so wrap or end with a literal default.
- **`one(list)`**, `lookup(map, key, default)` and conditional expressions (`x != null ? x.y : "n/a"`) for the other shapes.
- Better yet, **normalise early**: give the variable `optional(type, default)` defaults so downstream code never sees null.

Don't overuse `try()`: it can also mask typos (`item.claim.holdre` would quietly fall back to "UNCLAIMED"). Keep each
`try` wrapped around the smallest possible expression and test with data that has both shapes, which is what the validator does with its own items.
