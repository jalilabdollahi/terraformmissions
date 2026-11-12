# Debrief — sets have no first element

A `set` is a collection of unique values with no inherent order. Terraform may display a set's
elements sorted, but that is an implementation detail, not a contract, and sets of other types are
ordered by their own internal rules. Because "element zero" would be meaningless, `set[0]` is an
error: Terraform tells you instead of silently choosing an element that could change between versions.

When you need a position, convert explicitly:
- `tolist(set)` — creates a list, but its order is whatever Terraform chose; fine when you don't care.
- `sort(tolist(set))` — for strings, makes the order deterministic and reviewable.
- `element()` / `[n]` after sorting — now position has a meaning.

For sets of objects you cannot call `sort`; use a `for` expression with a key
(`[for g in set : g.name]`) and sort the keys, or choose a different type for the variable.

## Real-world takeaway

Use `set(string)` when duplicates are meaningless and order does not matter (security group IDs,
availability zones for `for_each`). Use `list(string)` when order is part of the meaning. If a later
change introduces "the first one", that is a sign the variable's type was wrong, or that you need an
explicit sort to turn the policy into code. Never rely on "it happens to come out in the same order" —
a provider upgrade can change it.
