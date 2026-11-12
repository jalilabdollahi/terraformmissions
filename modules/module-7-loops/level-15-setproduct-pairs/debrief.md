# Debrief - flatten nested loops into one map

A resource can only loop over one collection, so "every A with every B" has to be pre-computed. That is
what `setproduct()` does: it returns all combinations as a list of tuples. A `for_each` cannot use that
list directly (no keys, tuple elements), so you reshape it with a `for` expression into a map of objects
with stable string keys. Now each combination is an instance with its own address,
`local_file.booking["aria/fri"]`.

The key matters more than it looks. Because it is built from the *data* (room and day), adding a Sunday
creates three new instances and leaves the six existing ones alone. Had you used the list position as the
key, inserting a day in the middle would shift every later key and force Terraform to replace real
objects. The validator plans with a third day to make sure exactly that does not happen.

## Alternatives

Two nested `for` clauses with `flatten()` do the same job and handle cases where the inner list depends
on the outer item (rooms with different available days):
`merge([for r in rooms : { for d in days[r] : "${r}/${d}" => {...} }]...)`. Use `setproduct` for a true
cross product and `flatten` when the lists vary per item.

## Real-world takeaway

Security group rules per port per CIDR, DNS records per zone per record type, alarms per instance per
metric: these are all cross products. Build a locals map once, name the key after what it
identifies, and keep the resource block trivially simple.
