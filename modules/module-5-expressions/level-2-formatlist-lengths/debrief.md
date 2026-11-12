# Debrief — formatlist() and the length rule

`formatlist()` is `format()` applied row by row. You give it a template and one or more lists, and it
returns a list with one formatted string per row. For that to make sense, the lists have to line up,
so Terraform enforces one rule: **all list arguments must have the same length**. Arguments that are
not lists at all, a plain string or number, are reused for every row.

That second half is what makes the common pattern work: lists of things, plus a constant such as a
currency code, a region or a domain suffix. Pass the constant as it is and it behaves like a column
that repeats. Even a one-element list is not broadcast; it is a list of length one and must match.

The broken version tried to build the repeating column by hand with `["GBP", "GBP"]`. That is wrong
twice. It has the wrong number of rows today, and it silently hard-codes the currency and the number
of tiers, so the next person who adds a tier gets the same error again.

Note that the strict check protects you. Many languages would pad or truncate the shorter list;
Terraform refuses, because a misaligned price board (a price attached to the wrong tier) is worse than
a failed plan.

## Real-world takeaway

Reach for `formatlist()` when you need a list of ARNs, DNS names or labels derived from several
parallel inputs. When the lengths can differ, stop and ask whether the inputs are really parallel; if
they are not, use a `for` expression over the primary list and look up the secondary value by key.
And whenever you see a literal that repeats a variable's value, replace it with the variable.
