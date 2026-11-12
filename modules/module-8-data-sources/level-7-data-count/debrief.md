# Debrief — count turns a data source into a list

Adding `count` to a data block works exactly as it does for resources: instead of one object you get
a list of objects, addressed as `data.local_file.galley[0]`, `[1]` ... and the whole list is
`data.local_file.galley`. This mission tripped over both sides of that rule.

**Writing the instances.** Inside the block `count.index` is the zero-based position of the
current instance. Reaching for `count.index + 1` is an off-by-one that only fails on the last
instance, which is why the error mentions a list that is "too short" rather than pointing at the
arithmetic. Deriving `count` from `length(var.galleys)` and the element from the same list with the
same index keeps the two in step.

**Reading the instances.** Once `count` is present you can no longer write `data.local_file.galley.content`.
Use an index for a single element, or a `for` expression (or the splat `data.local_file.galley[*].content`)
for all of them. A `for` over the instances gives you a tuple whose order follows the input list.

That order is also the weakness of `count`: instances are tracked by position. Reorder the list and
instance 0 now reads a different file, so downstream things that were keyed by index change with it.
For data sources that is harmless (they are just re-read), but for resources it can mean destroy and
recreate. The next mission looks at `for_each`, which keys instances by name instead.
