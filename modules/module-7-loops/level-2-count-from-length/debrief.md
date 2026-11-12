# Debrief - let the data size the loop

A hard-coded `count` is a second copy of a fact that already lives in your data. The roster says five
dogs, the code says three, and they will drift apart the first time someone edits only one of them. In
this mission the drift was silent: Terraform happily indexed the first three entries and never looked
at the rest.

`count = length(var.dogs)` makes the list the single source of truth. A longer list creates new
instances at the end, a shorter list destroys instances from the end, and the code never needs editing
for routine roster changes.

## Real-world takeaway

Whenever you write a number next to `count`, ask where that number comes from. If it mirrors the size of
a list, a map or a set of subnets, derive it with `length()`. Then check the other direction too: what
happens when the list shrinks? With `count`, removal always happens from the highest index, so removing
a name from the *middle* of the list shifts every later element down one index and renames the
instances. That is exactly the weakness of `count` that `for_each` fixes, and the reason you will meet
`moved` blocks when migrating between the two later in this module.

The validator therefore tested three roster sizes: the default five, seven dogs and two dogs. A fix that
only works for the current list is a different hard-coded number.
