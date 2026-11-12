# Debrief — square brackets demand, lookup() offers

A map index like `var.rations_kg[horse]` is a demand: the key must exist or Terraform stops. That is
correct when a missing key means the data is wrong, and wrong when a missing key simply means "use
the usual value".

`lookup(map, key, default)` expresses the second situation. If the key is present the function
returns its value, otherwise the default. The difference matters for design:

- **Index** when absence is a bug, so you want the loud failure.
- **lookup() with default** when the map holds exceptions to a rule.
- **try()** when you want a fallback for any evaluation error, but be careful: it also hides typos.

Two details are easy to miss. First, `lookup()` without a third argument still errors on a missing
key, so the default is not optional for this use. Second, the default has to be convertible to the
map's value type; a string default with a map of numbers will make the whole result a map of strings.

Keeping the fallback in a variable (`standard_ration_kg`) rather than a literal makes the rule visible
and changeable in one place, and lets a test supply a different value to prove the fallback really is
being used.

## Real-world takeaway

Per-environment sizing tables, per-region AMI maps and per-team tags usually have an "everything else"
entry. Model that with `lookup()` and a named default instead of enumerating every possible key, and
decide deliberately for each map whether a missing key should fail loudly.
