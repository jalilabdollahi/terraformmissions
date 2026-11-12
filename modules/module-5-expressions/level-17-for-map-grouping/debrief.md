# Debrief — one key, many values

A `for` expression that builds a map, `{ for item in list : key => value }`, must produce unique keys.
When two elements generate the same key, Terraform does not choose a winner; it stops with a
"Duplicate object key" error, and tells you the way out.

That way out is **grouping mode**: write `...` after the value expression. The result is still a map,
but every value is now a list holding all values that shared that key, in the order they were seen.
The shape changes, which is easy to forget. Consumers must expect lists: `join()` and `length()` work
here, but a place that used `each.value` as a string will now see a list.

Grouping mode is the Terraform way to say "group by", the same idea as SQL's `GROUP BY` or
`itertools.groupby`. Typical uses:

- grouping instances by availability zone,
- collecting rules per security group,
- listing hostnames per subnet.

Alternatives and when they fit:

- **Unique composite key**, e.g. `"${a.belt}/${a.plate}"`, when you want one resource per item
  rather than per group.
- **`distinct()` or `toset()`** when you only need the unique keys, not their values.

Because the output is built from the input list in order, the lists keep serving order, which the
belt boards rely on.

## Real-world takeaway

Whenever you build a map from a list of records, ask "can two records share this key?" If yes, use
grouping or a composite key on purpose. A duplicate key error at plan time is the benign outcome;
silently overwriting entries, as some languages do, would drop plates from a board.
